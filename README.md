# Rails Devcontainer bootstrap

Codespaces-friendly Rails dev setup with:

- Fullstaq Ruby (https://github.com/evilmartians/fullstaq-ruby-docker)
- Volta for Node/Yarn
- Postgres + Redis
- gh for Github Copilot
- Devcontainer-compatible Docker setup


## Motivations

- 🧱 MacBooks with M1 chips make installing Ruby a pain
- 🐳 The dev `Dockerfile` mirrors production (uses Fullstaq Ruby in both)
- 🤖 GitHub Copilot can be instructed inside the devcontainer to open PRs with minimal setup

## Usage

Copy the `.copilot/` and `.devcontainer/` directories into your Rails app.

Optional: Copy `.github/copilot-instructions.md` , tailor it as needed, include architecture decisions and overviews

Configurations you more then likey need to change

in `.devcontainer/Dockerfile`:

- `ARG NODE_VERSION=20.12.2`
- `ARG BUNDLER_VERSION=2.4.21`
- `ARG YARN_VERSION=1.22.19`

## Future Enhancements

- 💡 **Version Management at Runtime**  
  Integrate tools like `asdf`, `nvm`, or `rbenv` to allow seamless switching between Ruby, Node, and Yarn versions at runtime—without rebuilding the dev container. This offers better alignment with `.ruby-version`, `.nvmrc`, and `.tool-versions` files for developer flexibility.

- ⌨️ **Improved Test Ergonomics**  
  Provide recommended keybindings for the `vscode-run-rspec-file` extension to streamline running individual specs directly from the editor.

---
