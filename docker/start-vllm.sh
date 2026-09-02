#!/bin/sh

set -u

MODEL="Qwen/Qwen2.5-Coder-7B-Instruct-GPTQ-Int4"
PORT="8001"
LOG="/app/logs/vllm.log"

export CUDA_VISIBLE_DEVICES="${CUDA_VISIBLE_DEVICES:-0}"
export VLLM_USE_V2_MODEL_RUNNER="${VLLM_USE_V2_MODEL_RUNNER:-0}"
export VLLM_USE_FLASHINFER_SAMPLER="${VLLM_USE_FLASHINFER_SAMPLER:-0}"

export PATH="/app/.local/bin:$PATH"
export PYTHONPATH="/app/.local/lib/python3.14/site-packages${PYTHONPATH:+:$PYTHONPATH}"

echo "[vLLM] Starting $MODEL on port $PORT"

exec /app/.local/bin/vllm serve "$MODEL" \
    --host 0.0.0.0 \
    --port "$PORT" \
    --max-model-len 24576 \
    --gpu-memory-utilization 0.85 \
    --max-num-seqs 1 \
    --enable-auto-tool-choice \
    --tool-call-parser hermes
