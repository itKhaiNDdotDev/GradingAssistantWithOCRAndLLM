from transformers import AutoTokenizer
import transformers
import torch

model = "bkai-foundation-models/vietnamese-llama2-7b-40GB"
access_token = "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"

tokenizer = AutoTokenizer.from_pretrained(model, token=access_token)
pipeline = transformers.pipeline(
    "text-generation",
    model=model,
    torch_dtype=torch.float16,
    device_map="auto",
    token=access_token
)

sequences = pipeline(
    'I liked "Breaking Bad" and "Band of Brothers". Do you have any recommendations of other shows I might like?\n',
    do_sample=True,
    top_k=10,
    num_return_sequences=1,
    eos_token_id=tokenizer.eos_token_id,
    max_length=200,
)
for seq in sequences:
    print(f"Result: {seq['generated_text']}")
