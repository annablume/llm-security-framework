-- Supabase RLS Policy Examples
-- Copy and adapt these for your tables. Run in the Supabase SQL editor or as a migration.
--
-- Key rules (see docs/LLM-Security-Guidelines.md Section 4):
--   • Use (select auth.uid()) — Postgres caches per statement, not per row (94-99% faster)
--   • Specify TO authenticated — skip evaluation for unauthenticated roles
--   • Guard against null: auth.uid() returns null for unauthenticated users
--   • Store roles in raw_app_meta_data (server-writable), not user_metadata (user-writable)
--   • Place security definer functions in a non-public schema
--   • Add indexes on columns used in policy conditions


-- ============================================================
-- 1. ENABLE RLS
-- ============================================================

-- Enable on a single table
ALTER TABLE public.posts ENABLE ROW LEVEL SECURITY;

-- Enable on all existing public tables at once (run during initial hardening)
DO $$
DECLARE
  tbl RECORD;
BEGIN
  FOR tbl IN
    SELECT tablename
    FROM pg_tables
    WHERE schemaname = 'public'
  LOOP
    EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY;', tbl.tablename);
  END LOOP;
END $$;

-- Audit: find public tables that still have RLS disabled
SELECT schemaname, tablename
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename NOT IN (
    SELECT DISTINCT tablename FROM pg_policies
  );


-- ============================================================
-- 2. USER OWNS THEIR OWN ROWS
-- ============================================================

CREATE POLICY "users_select_own_posts"
  ON public.posts
  FOR SELECT
  TO authenticated
  USING ((select auth.uid()) = user_id);

CREATE POLICY "users_insert_own_posts"
  ON public.posts
  FOR INSERT
  TO authenticated
  WITH CHECK ((select auth.uid()) = user_id);

CREATE POLICY "users_update_own_posts"
  ON public.posts
  FOR UPDATE
  TO authenticated
  USING ((select auth.uid()) = user_id)
  WITH CHECK ((select auth.uid()) = user_id);

CREATE POLICY "users_delete_own_posts"
  ON public.posts
  FOR DELETE
  TO authenticated
  USING ((select auth.uid()) = user_id);


-- ============================================================
-- 3. PUBLIC READ, OWNER WRITE
-- (published articles, public profiles)
-- ============================================================

CREATE POLICY "public_read_published_articles"
  ON public.articles
  FOR SELECT
  USING (published = true);

CREATE POLICY "owner_insert_articles"
  ON public.articles
  FOR INSERT
  TO authenticated
  WITH CHECK ((select auth.uid()) = author_id);

CREATE POLICY "owner_update_articles"
  ON public.articles
  FOR UPDATE
  TO authenticated
  USING ((select auth.uid()) = author_id)
  WITH CHECK ((select auth.uid()) = author_id);

CREATE POLICY "owner_delete_articles"
  ON public.articles
  FOR DELETE
  TO authenticated
  USING ((select auth.uid()) = author_id);


-- ============================================================
-- 4. ORGANISATION / TEAM MEMBERSHIP
-- (rows scoped to a workspace or org)
-- ============================================================

-- Array lookup is more performant than EXISTS for large membership tables
CREATE POLICY "org_members_select_documents"
  ON public.documents
  FOR SELECT
  TO authenticated
  USING (
    org_id = ANY (
      SELECT org_id
      FROM public.org_members
      WHERE user_id = (select auth.uid())
    )
  );

CREATE POLICY "org_members_insert_documents"
  ON public.documents
  FOR INSERT
  TO authenticated
  WITH CHECK (
    org_id = ANY (
      SELECT org_id
      FROM public.org_members
      WHERE user_id = (select auth.uid())
    )
  );


-- ============================================================
-- 5. ROLE-BASED ACCESS USING raw_app_meta_data
-- IMPORTANT: raw_app_meta_data is set server-side only.
-- NEVER use user_metadata for authorization — users can edit it.
-- ============================================================

-- Admins see all orders
CREATE POLICY "admins_select_all_orders"
  ON public.orders
  FOR SELECT
  TO authenticated
  USING (
    (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin'
  );

-- Regular users see only their own orders
CREATE POLICY "users_select_own_orders"
  ON public.orders
  FOR SELECT
  TO authenticated
  USING ((select auth.uid()) = user_id);


-- ============================================================
-- 6. SECURITY DEFINER HELPER FUNCTIONS
-- Place in a non-public schema — not exposed via PostgREST API.
-- ============================================================

CREATE SCHEMA IF NOT EXISTS private;

CREATE OR REPLACE FUNCTION private.is_admin()
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
  SELECT (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin';
$$;

CREATE POLICY "admins_delete_any_post"
  ON public.posts
  FOR DELETE
  TO authenticated
  USING (private.is_admin());


-- ============================================================
-- 7. NULL GUARD
-- auth.uid() = null comparisons silently fail (evaluate to null,
-- not false). Be explicit when enforcing authentication.
-- ============================================================

CREATE POLICY "authenticated_only_private_notes"
  ON public.private_notes
  FOR SELECT
  TO authenticated
  USING (
    auth.uid() IS NOT NULL
    AND (select auth.uid()) = user_id
  );


-- ============================================================
-- 8. PROFILES TABLE (common pattern)
-- ============================================================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "public_profiles_viewable"
  ON public.profiles
  FOR SELECT
  USING (true);

CREATE POLICY "users_update_own_profile"
  ON public.profiles
  FOR UPDATE
  TO authenticated
  USING ((select auth.uid()) = id)
  WITH CHECK ((select auth.uid()) = id);


-- ============================================================
-- 9. AUTO-CREATE PROFILE ON SIGN-UP
-- ============================================================

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, created_at)
  VALUES (NEW.id, now());
  RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();


-- ============================================================
-- 10. PERFORMANCE: INDEXES ON POLICY COLUMNS
-- RLS policies filter by these columns on every query.
-- Without indexes, Postgres scans the full table each time.
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_posts_user_id         ON public.posts(user_id);
CREATE INDEX IF NOT EXISTS idx_articles_author_id    ON public.articles(author_id);
CREATE INDEX IF NOT EXISTS idx_orders_user_id        ON public.orders(user_id);
CREATE INDEX IF NOT EXISTS idx_org_members_user_id   ON public.org_members(user_id);
CREATE INDEX IF NOT EXISTS idx_documents_org_id      ON public.documents(org_id);
CREATE INDEX IF NOT EXISTS idx_private_notes_user_id ON public.private_notes(user_id);
