#!/usr/bin/env bash
# Deploy the DRS Management concept site (drsm/) to Cloudflare Pages.
#
# Requires:
#   CLOUDFLARE_API_TOKEN  - API token with permission: Account -> Cloudflare Pages -> Edit
#                           (create at dash.cloudflare.com -> My Profile -> API Tokens)
#   CLOUDFLARE_ACCOUNT_ID - only needed if the token can see multiple accounts
#
# Usage:
#   ./deploy-drsm.sh              # deploys to project "drsm-concept"
#   ./deploy-drsm.sh my-project   # deploys to a custom project name
set -euo pipefail

PROJECT="${1:-drsm-concept}"
DIR="$(cd "$(dirname "$0")" && pwd)/drsm"

if [ -z "${CLOUDFLARE_API_TOKEN:-}" ]; then
  echo "error: CLOUDFLARE_API_TOKEN is not set" >&2
  exit 1
fi

# Create the project if it doesn't exist yet, then deploy.
npx --yes wrangler@4 pages project create "$PROJECT" --production-branch main 2>/dev/null \
  || echo "project '$PROJECT' already exists — deploying to it"
npx --yes wrangler@4 pages deploy "$DIR" --project-name "$PROJECT"
