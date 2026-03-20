# llama-launch

Linux-first launcher for a local `llama.cpp` server, coding-oriented model profiles, and Open WebUI.

This repo is intentionally small:
- Ubuntu shell launcher only
- no Windows PowerShell scripts
- no private keys or machine-specific secrets
- no benchmark dumps

## What It Does

- starts `llama-server` with predefined local profiles
- switches between a few practical coding and chat profiles
- optionally launches Open WebUI against the local server
- optionally launches `aider` against the local server
- optionally launches `claude` or `opencode` against the local server

## Requirements

- Ubuntu or similar Linux distro
- built `llama.cpp` with CUDA support
- local model files under `~/models`
- optional:
  - `open-webui` in a venv at `~/open-webui-venv`
  - `aider`
  - `claude` CLI
  - `opencode`

## Install

1. Clone the repo:

```bash
git clone git@github.com:charpdev/llama-launch.git
cd llama-launch
```

2. Make the scripts executable:

```bash
chmod +x llm-launch start-open-webui.sh
```

3. Build `llama.cpp` or point `LLAMA_BIN` at an existing binary.

Expected default path:

```bash
~/code/llama.cpp/build/bin/llama-server
```

4. Put your models under `~/models` using the same relative layout used in the script, or edit the profile paths in `llm-launch`.

5. Optional: set a Brave key for Open WebUI search:

```bash
mkdir -p ~/.config/llama-launch
cat > ~/.config/llama-launch/brave-search.env <<'EOF'
export BRAVE_SEARCH_API_KEY="your_key_here"
EOF
```

## Usage

Interactive:

```bash
./llm-launch
```

Choose a profile directly:

```bash
./llm-launch --profile qwen3-coder-30b-ud-q3kxl
./llm-launch --profile qwen3-coder-30b-ud-q3kxl-96k
./llm-launch --profile qwen35-35b-ud-q2kxl
```

Launch an IDE after selecting the profile:

```bash
./llm-launch claude
./llm-launch aider
./llm-launch opencode
```

Start Open WebUI:

```bash
./start-open-webui.sh
```

## Default Profiles

- `jackrong-27b-q3ks`
  Reasoning/chat profile
- `hauhau-27b-q3km`
  Uncensored 27B profile
- `qwen3-coder-30b-ud-q3kxl`
  Fast default coding profile
- `qwen3-coder-30b-ud-q3kxl-96k`
  Higher-context 30B coding profile
- `qwen35-35b-q4km`
  Experimental 35B coding profile
- `qwen35-35b-ud-q2kxl`
  Fast 35B coding profile

## Notes

- The launcher disables reasoning for the coding profiles by default.
- `qwen35-35b-*` no-think profiles use the custom template in `templates/qwen3_no_empty_think.jinja` to avoid broken empty think tags.
- Open WebUI search is enabled only if `BRAVE_SEARCH_API_KEY` is available.

## Example llama.cpp Build

```bash
git clone https://github.com/ggml-org/llama.cpp
cd llama.cpp
cmake -B build \
  -DGGML_CUDA=ON \
  -DCMAKE_CUDA_COMPILER=/usr/local/cuda-12.9/bin/nvcc \
  -DCMAKE_C_COMPILER=gcc-12 \
  -DCMAKE_CXX_COMPILER=g++-12
cmake --build build -j --target llama-server
```
