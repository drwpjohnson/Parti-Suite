# Utah Site Redirect

This folder contains the HTML redirect page that replaces the original
Parti-Suite download page at:

    https://wpjohnsongroup.utah.edu/trajectoryCodes.html

## Background

Parti-Suite was previously distributed from the W.P. Johnson Research Group
website at the University of Utah. When the suite migrated to GitHub, the
original download page was replaced with this single redirect file to
preserve existing citations in published papers and the companion textbook
(Johnson and Pazmiño, 2023).

The redirect page:

- Forwards visitors to the GitHub repository automatically after 5 seconds
  via a `<meta http-equiv="refresh">` tag
- Provides a manually clickable link in case the automatic redirect fails
- Sets a canonical URL pointing to the GitHub repository for search engines
- Displays a brief explanation of the migration for users who land on the
  page directly

## Deployment

The file `trajectoryCodes.html` in this folder is intended to replace the
existing `trajectoryCodes.html` at `wpjohnsongroup.utah.edu`. Deployment
is handled by the University of Utah IT department; see the project
migration records for correspondence.

## Why This Is in the Repository

Archiving the redirect file here serves several purposes:

1. **Canonical copy.** If the Utah-hosted file is ever lost, corrupted, or
   inadvertently replaced, this is the authoritative version to re-upload.
2. **Historical record.** Git history preserves the exact content served
   at the Utah URL after the migration, and any future changes to it.
3. **Transparency.** Anyone browsing the repository who wonders how old
   citations still resolve can find the explanation here.

## Editing

If the redirect page needs to be updated (e.g., the GitHub organization or
repository name changes, styling is revised, or the wording needs
adjustment), edit `trajectoryCodes.html` here first, commit the change to
Git, then coordinate with University of Utah IT to deploy the updated file
to the Utah server. Keeping the repo copy and the deployed copy in sync
ensures Git history remains a faithful record of what's actually served.
