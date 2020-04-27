#!/bin/bash

## Variables
FORECAST_FOLDER=$1
STEPS=100
PRETRAINED_PRESUMM_PATH="../models/bertextabs.pt"
LOG_NAME="${FORECAST_FOLDER}.log"
TRAIN_FOLDER=$2
FINETUNED_MODEL_PATH="../models/${TRAIN_FOLDER}.pt"
# FINETUNED_MODEL="../models/${TRAIN_FOLDER}.pt/model_step_148100.pt"
FINETUNED_MODEL="../models/${TRAIN_FOLDER}.pt/model_step_$((148000+STEPS)).pt"

## Preprocessing

### Splitting and tokenization
mkdir "../merged_stories_tokenized/$FORECAST_FOLDER/"
echo 'dummy text' > "../logs/$LOG_NAME"
python preprocess.py -mode tokenize -raw_path "../raw_data/$FORECAST_FOLDER/" -save_path "../merged_stories_tokenized/$FORECAST_FOLDER/" -log_file "../logs/$LOG_NAME"

### Simpler json files
mkdir "../json_data/$FORECAST_FOLDER/"
python preprocess.py -mode format_to_lines -raw_path "../merged_stories_tokenized/$FORECAST_FOLDER/" -save_path "../json_data/$FORECAST_FOLDER/" -n_cpus 1 -use_bert_basic_tokenizer false -log_file "../logs/$LOG_NAME" -shard_size 20000

### Pytorch files
mkdir "../bert_data/$FORECAST_FOLDER/"
python preprocess.py -mode format_to_bert -raw_path "../json_data/$FORECAST_FOLDER/" -save_path "../bert_data/$FORECAST_FOLDER/" -lower -n_cpus 1 -log_file "../logs/$LOG_NAME" -min_src_nsents 1 -max_src_nsents 500 -min_src_ntokens_per_sent 3 -max_src_ntokens_per_sent 500 -shard_size 20000

## Inference

### Prepare data
cp "../bert_data/$FORECAST_FOLDER/.train.0.bert.pt" "../bert_data/$FORECAST_FOLDER/.bert.0.test.pt"

## Generate titles
python train.py -task abs -mode test -batch_size 16 -test_batch_size 500 -bert_data_path "../bert_data/$FORECAST_FOLDER/.bert.0" -log_file "../logs/$LOG_NAME" -model_path "$FINETUNED_MODEL_PATH" -sep_optim true -use_interval true -visible_gpus 0 -max_pos 512 -max_length 200 -alpha 0.95 -min_length 10 -result_path "../logs/$LOG_NAME" -test_from "$FINETUNED_MODEL"

