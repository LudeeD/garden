# Luís's Garden

Personal blog built with Zola.

## Commands

```bash
# Serve locally
zola serve

# Build site
zola build

# Check for issues
zola check
```

## Adding Posts

Create `.md` files in `content/` with frontmatter:

```markdown
---
title: "Post Title"
date: 2025-01-01
[contexts] = ["Essay"]
[tags] = ["tag1"]
---

Content here...
```

Site outputs to `docs/` directory.