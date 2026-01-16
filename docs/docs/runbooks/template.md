---
sidebar_position: 999
---

# Runbook Template

Use this template when creating new runbooks. Copy this file and fill in each section.

---

```markdown
---
sidebar_position: [number - see overview.md for position ranges]
---

# [Runbook Title]

[1-2 sentence description of what this runbook covers and when to use it.]

## Quick Links

| Resource | Link |
|----------|------|
| Dashboard | [Dashboard Name](https://...) |
| Alerts | [Monitor](https://...) |
| Slack | #channel-name |
| Contacts | Team or owners |
| Architecture | [Component Architecture](../architecture/component.md) |

## Prerequisites

Before starting, ensure you have:

- [ ] Access requirement 1 (link to access runbook if applicable)
- [ ] Access requirement 2
- [ ] Tools installed: `tool1`, `tool2`

Verify access:

\`\`\`bash
# Verify you can access the system
your-verification-command
\`\`\`

## Architecture Context

[Brief explanation of how this component fits into the larger system. Include a simple ASCII diagram if helpful.]

\`\`\`
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ Component A │────▶│ This System │────▶│ Component B │
└─────────────┘     └─────────────┘     └─────────────┘
\`\`\`

For detailed architecture, see [Component Architecture](../architecture/component.md).

## Procedures

### Procedure 1: [Task Name]

**When to use:** [Trigger conditions - what alert, what symptom, what request]

**Impact:** [What happens if you do/don't do this - helps operator understand urgency]

#### Steps

1. **[Step description]**

   \`\`\`bash
   # Explanation of what this command does
   actual-command --with-flags
   \`\`\`

   Expected output:
   \`\`\`
   [Example output the operator should see]
   \`\`\`

2. **[Next step]**

   [Description and command...]

#### Verification

Confirm the operation succeeded:

\`\`\`bash
# Command to verify success
verification-command
\`\`\`

Expected result: [Describe what success looks like]

### Procedure 2: [Another Task]

[Same structure as above...]

## Troubleshooting

### Issue 1: [Symptom Description]

| Aspect | Details |
|--------|---------|
| **Symptom** | What the operator observes (error message, behavior) |
| **Cause** | Why this happens |
| **Diagnosis** | Commands to confirm this is the issue |
| **Solution** | Steps to resolve |

\`\`\`bash
# Diagnostic command
diagnostic-command

# Fix command
fix-command
\`\`\`

### Issue 2: [Another Symptom]

[Same structure...]

## Failure Modes

| Failure | Symptoms | Diagnosis | Recovery |
|---------|----------|-----------|----------|
| [Mode 1] | What you observe | How to confirm | Steps to fix |
| [Mode 2] | ... | ... | ... |
| [Mode 3] | ... | ... | ... |

## Monitoring

### Key Metrics

| Metric | Normal | Warning | Critical |
|--------|--------|---------|----------|
| `metric.name.one` | < 100 | 100-500 | > 500 |
| `metric.name.two` | > 99% | 95-99% | < 95% |

### Dashboard Links

- [Primary Dashboard](https://...)
- [Component Metrics](https://...)

## Alerts

| Alert | Severity | Response |
|-------|----------|----------|
| [Alert Name] | P1/P2/P3 | [Link to procedure](#procedure-name) |
| [Another Alert] | P2 | [Link to procedure](#another-procedure) |

## Configuration Reference

| Parameter | Value | Description |
|-----------|-------|-------------|
| `config_param_one` | `value` | What this controls |
| `config_param_two` | `value` | What this controls |

## Related

- [Related Runbook 1](./related-runbook.md) - When you might also need this
- [Architecture Doc](../architecture/component.md) - Detailed technical design
- [Repository](https://github.com/...) - Source code
```

---

## Template Guidelines

### Sidebar Positioning

Use these position ranges to maintain logical grouping:

| Range | Category |
|-------|----------|
| 1 | Overview (reserved) |
| 2-9 | Incident Response |
| 10-19 | Core Operations |
| 20-29 | Infrastructure |
| 30-39 | Monitoring |
| 40-49 | Deployment |
| 50-59 | Maintenance |
| 999 | Template (this file) |

### Section Requirements

**Required sections:**
- Quick Links
- Prerequisites
- At least one Procedure with Verification
- Troubleshooting (at least one issue)
- Related links

**Recommended sections:**
- Architecture Context (for complex systems)
- Failure Modes table (for operational procedures)
- Monitoring section (for systems with metrics)
- Alerts section (for systems with monitors)

### Writing Style

- Use imperative mood: "Run the command" not "You should run the command"
- Include actual commands, not placeholders when possible
- Show expected output to help operators confirm success
- Link to architecture docs for "why", keep runbooks focused on "how"
- Keep procedures focused on a single task
- Order procedures by frequency of use (most common first)

### Verification Steps

Every procedure should include:
1. A verification command that confirms success
2. Expected output or state description
3. What to do if verification fails (link to troubleshooting)

### Cross-References

- Link to architecture docs for technical background
- Link to other runbooks for related operations
- Link to alerts reference for alert details
- Use relative paths: `./other-runbook.md`, `../architecture/component.md`
