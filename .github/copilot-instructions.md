<!-- These instructions give context for all Copilot chats. The instructions you add to this file should be short, self-contained statements that add context or relevant information to supplement users' chat questions. See docs: https://docs.github.com/en/copilot/customizing-copilot/adding-repository-custom-instructions-for-github-copilot#writing-effective-repository-custom-instructions -->

# Copilot Instructions for eliminator

## Overview
eliminator is a full-stack Ruby on Rails application powered by Hotwire. It follows Rails 7 conventions with the following setup:
- Uses esbuild instead of importmaps, enabling future support for TypeScript and React.
- Uses the Clearance gem for authentication (instead of Devise or Rails 8’s built-in auth).
- Uses Yarn v1 to manage npm packages.
- Uses Bootstrap 5 with SCSS (not Tailwind).
- Includes a Sinatra application called `horses` in `lib/horses`, integrated into the main Rails app (shared Gemfile and routes). See `README.md` in the root directory for details.

## Architecture & Patterns
- Uses Sidekiq for background jobs.
- Uses Cypress for end-to-end testing.
- Move business logic out of views and controllers into helpers or presenters.
- Use helpers for calculations, formatting, and conditional logic unrelated to rendering.

## Migrations
- Data migrations must be implemented as rake seed tasks, not as part of standard Rails database migrations.
- Index updates must be included in dedicated migration files (do not combine with other changes).

## Code Quality
- Uses RuboCop for linting.
- Ensure code passes all linter checks before committing.
- Only document complex methods; avoid comments that explain thought process or trivial logic.
- Remove unreachable or dead code from views.

## Testing
- Prefer request specs for API tests over controller specs.
- Use FactoryBot for test data.
- Write integration ("social") tests that verify actual business logic. Use isolated ("solitary") unit tests sparingly.
- Use fakes like WebMock in integration tests when appropriate.
- Prefer RSpec for all testing.

## Git Practices
- Branch names should use author initials followed by a short description with underscores, max 80 characters.
- Use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) (`fix:`, `feat:`, `chore:`, etc.).
- Reference related issues in commit messages: `See: https://github.com/jeremy04/eliminator/issues/123`.
- Pull requests must be based on `main`, use a conventional commit-style title, and pass all CI checks before review.

## Tips for Copilot
- Prefer existing patterns and structure.
- Reuse helpers and services when possible.
- Write clear, concise code.
- Focus on maintainability and readability.
- Ask for clarification if requirements are ambiguous.
- Follow the conventions and patterns already established in the codebase.
