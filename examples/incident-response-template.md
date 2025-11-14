# Security Incident Report Template

**Incident ID**: INC-[YYYY-MM-DD]-[XXX]  
**Date Opened**: [Date]  
**Time Opened**: [Time UTC]  
**Severity**: [ ] P0-Critical | [ ] P1-High | [ ] P2-Medium | [ ] P3-Low  
**Status**: [ ] Open | [ ] Investigating | [ ] Contained | [ ] Resolved | [ ] Closed  
**Incident Commander**: [Name]  
**Security Lead**: [Name]  

---

## 🚨 Executive Summary

**What Happened** (1-2 sentences):
[Brief description of the incident]

**Impact**: 
[Who/what was affected]

**Current Status**:
[Contained/Ongoing/Resolved]

**Action Required**:
[Any immediate actions needed from leadership]

---

## 📋 Incident Details

### Type of Incident
[ ] Secret Leak (API keys, tokens, passwords)  
[ ] Data Breach (PII, customer data)  
[ ] Prompt Injection  
[ ] Malicious Code Injection  
[ ] Unauthorized Access  
[ ] Supply Chain Attack  
[ ] Social Engineering  
[ ] DDoS/Service Disruption  
[ ] Other: _______________

### Discovery Method
[ ] Automated scan (Gitleaks, Dependabot, etc.)  
[ ] Manual code review  
[ ] User report  
[ ] Security alert  
[ ] External notification  
[ ] Other: _______________

### Initial Detection
**Detected By**: [Name/Tool]  
**Detection Time**: [Time UTC]  
**Detection Method**: [How was it discovered]  

---

## ⏱️ Timeline

| Time (UTC) | Event | Action Taken | By Whom |
|------------|-------|--------------|---------|
| [HH:MM] | Incident detected | [Action] | [Name] |
| [HH:MM] | Initial assessment completed | [Action] | [Name] |
| [HH:MM] | Containment started | [Action] | [Name] |
| [HH:MM] | Stakeholders notified | [Action] | [Name] |
| [HH:MM] | Root cause identified | [Action] | [Name] |
| [HH:MM] | Remediation deployed | [Action] | [Name] |
| [HH:MM] | Incident resolved | [Action] | [Name] |
| [HH:MM] | Post-mortem scheduled | [Action] | [Name] |

**Total Duration**: [X hours/days]  
**Time to Detect**: [Time from occurrence to detection]  
**Time to Contain**: [Time from detection to containment]  
**Time to Resolve**: [Time from detection to full resolution]

---

## 🔍 Technical Details

### What Happened

**Root Cause**:
```
[Detailed explanation of what caused the incident]
```

**Attack Vector** (if applicable):
```
[How did the attacker/issue gain access or occur]
```

**Vulnerability Exploited**:
```
[What weakness was exploited - configuration error, code bug, etc.]
```

### Affected Systems

**Infrastructure Components**:
- [ ] Production environment
- [ ] Staging environment
- [ ] Development environment
- [ ] CI/CD pipeline
- [ ] Monitoring/logging systems
- [ ] Backup systems

**Applications/Services**:
- [ ] Web application
- [ ] API
- [ ] Database
- [ ] Edge functions
- [ ] Background jobs
- [ ] Authentication service

**Specific Details**:
```
Repository: [repo-name]
Branch: [branch-name]
Commit: [commit-hash]
Files affected: [list of files]
Systems: [list of systems]
```

### Data/Credentials Exposed

**Type of Data**:
- [ ] API Keys
- [ ] Database credentials
- [ ] Service account tokens
- [ ] Customer PII
- [ ] Financial data
- [ ] Authentication tokens
- [ ] Source code
- [ ] Configuration files
- [ ] Other: _______________

**Exposure Details**:
```
Credential Type: [e.g., Supabase Service Role Key]
Exposed In: [e.g., Git commit abc123, Netlify logs, etc.]
First Exposure: [Date/Time]
Last Exposure: [Date/Time]
Scope: [What access this credential provides]
```

**Estimated Records Affected**: [Number]  
**User Accounts Affected**: [Number or N/A]  
**Geographic Scope**: [Regions affected]

---

## 🚨 Impact Assessment

### Business Impact
**Severity Justification**:
```
[Why this severity level was assigned]
```

**Service Availability**:
- Downtime: [Duration or N/A]
- Degraded performance: [Duration or N/A]
- Services affected: [List]

**Financial Impact**:
- Direct costs: $[Amount]
- Recovery costs: $[Amount]
- Potential liability: $[Amount or Unknown]

**Reputation Impact**:
- [ ] None
- [ ] Minor
- [ ] Moderate
- [ ] Significant
- [ ] Severe

### Security Impact

**Confidentiality**: [ ] None | [ ] Low | [ ] Medium | [ ] High | [ ] Critical  
**Integrity**: [ ] None | [ ] Low | [ ] Medium | [ ] High | [ ] Critical  
**Availability**: [ ] None | [ ] Low | [ ] Medium | [ ] High | [ ] Critical

**Data Breach?**: [ ] Yes | [ ] No | [ ] Unknown

If yes:
- **Notification Required**: [ ] Yes | [ ] No
- **Regulatory Bodies**: [List if applicable - GDPR, CCPA, etc.]
- **Notification Deadline**: [Date]

---

## 🛡️ Response Actions

### Immediate Containment (Within 30 minutes)

**Actions Taken**:
1. [Action 1] - Completed at [Time] by [Name]
2. [Action 2] - Completed at [Time] by [Name]
3. [Action 3] - Completed at [Time] by [Name]

**Credentials Rotated**:
```
Service: Supabase
Old Key: service_role_xxx...xxx
New Key: service_role_yyy...yyy
Rotated At: [Time]
Rotated By: [Name]
```

**Access Revoked**:
```
[List any access that was immediately revoked]
```

**Systems Isolated**:
```
[Any systems taken offline or isolated]
```

### Eradication

**Malicious Code Removed**:
- Commits reverted: [List commit hashes]
- Files cleaned: [List files]
- History cleaned: [ ] Yes | [ ] No (if yes, describe method)

**Vulnerabilities Patched**:
- [Vulnerability 1] - Patched at [Time]
- [Vulnerability 2] - Patched at [Time]

**Security Controls Added**:
- [Control 1]
- [Control 2]

### Recovery

**Services Restored**:
- [Service 1] - Restored at [Time]
- [Service 2] - Restored at [Time]

**Verification Steps**:
- [ ] Security scans completed
- [ ] Access logs reviewed
- [ ] Monitoring verified
- [ ] Backups validated
- [ ] User access tested

**Monitoring Enhanced**:
```
New alerts configured:
- [Alert 1]
- [Alert 2]

Additional logging enabled:
- [Log 1]
- [Log 2]
```

---

## 📞 Communications

### Internal Notifications

**Who Was Notified**:
- [x] Security Team - at [Time]
- [x] Engineering Team - at [Time]
- [ ] Executive Team - at [Time]
- [ ] Legal - at [Time]
- [ ] PR/Communications - at [Time]

**Notification Method**: [Email/Slack/PagerDuty/etc.]

**Message Sent**:
```
[Copy of notification message]
```

### External Notifications

**Customers Notified**: [ ] Yes | [ ] No | [ ] N/A  
**Notification Date**: [Date]  
**Method**: [Email/In-app/Website/etc.]

**Partners/Vendors Notified**:
- [ ] Supabase - at [Time]
- [ ] Netlify - at [Time]
- [ ] Anthropic - at [Time]
- [ ] GitHub - at [Time]

**Regulatory Notifications**:
- [ ] Required | [ ] Not Required
- If required: [Which authorities, when notified]

---

## 🔬 Root Cause Analysis

### Contributing Factors

**Direct Cause**:
```
[What directly caused the incident]
```

**Contributing Factors**:
1. [Factor 1]
2. [Factor 2]
3. [Factor 3]

**Why Did Defenses Fail?**:
```
[Analysis of why existing controls didn't prevent/detect this]
```

### Five Whys Analysis

1. **Why did [incident] occur?**
   - [Answer]

2. **Why [answer from #1]?**
   - [Answer]

3. **Why [answer from #2]?**
   - [Answer]

4. **Why [answer from #3]?**
   - [Answer]

5. **Why [answer from #4]?**
   - [Answer - this is usually the root cause]

**Root Cause**: [Final root cause from Five Whys]

---

## 📊 Evidence Collection

### Logs Preserved
- [ ] Application logs
- [ ] Access logs
- [ ] Audit logs
- [ ] Git history
- [ ] CI/CD logs
- [ ] Network logs

**Evidence Location**: [Path/URL to preserved evidence]

### Artifacts
```
Commit hashes: [list]
Screenshots: [location]
Code samples: [location]
Log files: [location]
Network captures: [location]
```

### Forensic Analysis
**Tools Used**:
- [Tool 1]
- [Tool 2]

**Key Findings**:
- [Finding 1]
- [Finding 2]

---

## ✅ Lessons Learned

### What Went Well
1. [Positive aspect 1]
2. [Positive aspect 2]
3. [Positive aspect 3]

### What Went Wrong
1. [Problem 1]
2. [Problem 2]
3. [Problem 3]

### What Got Lucky
1. [Lucky break 1]
2. [Lucky break 2]

---

## 🎯 Action Items

### Prevention

| Action Item | Owner | Due Date | Priority | Status |
|-------------|-------|----------|----------|--------|
| [Specific action to prevent recurrence] | [Name] | [Date] | P0 | [ ] Not Started / [ ] In Progress / [ ] Done |
| [Another preventive measure] | [Name] | [Date] | P1 | [ ] Not Started / [ ] In Progress / [ ] Done |
| [Another preventive measure] | [Name] | [Date] | P2 | [ ] Not Started / [ ] In Progress / [ ] Done |

### Detection

| Action Item | Owner | Due Date | Priority | Status |
|-------------|-------|----------|----------|--------|
| [Improve detection capability] | [Name] | [Date] | P0 | [ ] Not Started / [ ] In Progress / [ ] Done |
| [Add monitoring/alerting] | [Name] | [Date] | P1 | [ ] Not Started / [ ] In Progress / [ ] Done |

### Response

| Action Item | Owner | Due Date | Priority | Status |
|-------------|-------|----------|----------|--------|
| [Improve response procedure] | [Name] | [Date] | P1 | [ ] Not Started / [ ] In Progress / [ ] Done |
| [Update runbooks] | [Name] | [Date] | P2 | [ ] Not Started / [ ] In Progress / [ ] Done |

### Documentation

| Action Item | Owner | Due Date | Priority | Status |
|-------------|-------|----------|----------|--------|
| [Update security guidelines] | [Name] | [Date] | P1 | [ ] Not Started / [ ] In Progress / [ ] Done |
| [Create training materials] | [Name] | [Date] | P2 | [ ] Not Started / [ ] In Progress / [ ] Done |

---

## 🔧 Technical Improvements Implemented

### Immediate Fixes
```
Description: [What was fixed]
Commit: [commit-hash]
Deployed: [Date/Time]
Verified: [Date/Time]
```

### Configuration Changes
```yaml
# Before
old_config: value

# After
new_config: value
```

### New Controls Added
1. **Control Name**: [Description]
   - Implementation: [How it was implemented]
   - Effectiveness: [Expected impact]

2. **Control Name**: [Description]
   - Implementation: [How it was implemented]
   - Effectiveness: [Expected impact]

---

## 📈 Metrics

**Detection Metrics**:
- Time to detect: [Duration]
- Detection method: [Automated/Manual]
- Alert accuracy: [True positive/false positive]

**Response Metrics**:
- Time to acknowledge: [Duration]
- Time to contain: [Duration]
- Time to resolve: [Duration]
- Time to recover: [Duration]

**Business Metrics**:
- Users affected: [Number]
- Revenue impact: $[Amount]
- SLA breach: [ ] Yes | [ ] No

---

## 🔒 Closure

### Resolution Summary
```
[Brief summary of how the incident was resolved]
```

### Verification
- [ ] All affected systems verified secure
- [ ] All credentials rotated
- [ ] All vulnerabilities patched
- [ ] Monitoring confirmed working
- [ ] Users can access services
- [ ] No ongoing suspicious activity

### Sign-off

**Incident Commander**: _____________________ Date: _______  
**Security Team Lead**: _____________________ Date: _______  
**Engineering Lead**: _____________________ Date: _______  
**[Executive/CISO]**: _____________________ Date: _______  

### Post-Incident Review

**Review Meeting Scheduled**: [Date/Time]  
**Attendees**: [List]  
**Review Completed**: [ ] Yes | [ ] No  
**Review Notes**: [Link to notes]

---

## 📎 Attachments

1. [Evidence file 1]
2. [Log file 2]
3. [Screenshot 3]
4. [Report 4]

---

## 📝 Notes

```
[Any additional notes, observations, or context]
```

---

**Document Created**: [Date]  
**Last Updated**: [Date]  
**Document Owner**: [Name]  
**Classification**: CONFIDENTIAL - INTERNAL ONLY

---

## Appendix A: Related Incidents

| Incident ID | Date | Type | Similarity | Lessons Applied? |
|-------------|------|------|------------|------------------|
| [INC-ID] | [Date] | [Type] | [How similar] | [ ] Yes / [ ] No |

---

## Appendix B: External References

- Vulnerability: [CVE-XXXX-XXXXX]
- Security Advisory: [Link]
- Vendor Communication: [Link]
- Industry Report: [Link]

---

*Template Version: 2.0*  
*Last Updated: November 2025*