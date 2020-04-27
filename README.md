# PreSumm

**This is a fork of the code for EMNLP 2019 paper [Text Summarization with Pretrained Encoders](https://arxiv.org/abs/1908.08345)**
Results on CNN/DailyMail (20/8/2019):

<table class="tg">
  <tr>
    <th class="tg-0pky">Models</th>
    <th class="tg-0pky">ROUGE-1</th>
    <th class="tg-0pky">ROUGE-2</th>
    <th class="tg-0pky">ROUGE-L</th>
  </tr>
  <tr>
    <td class="tg-c3ow" colspan="4">Extractive</td>
  </tr>
  <tr>
    <td class="tg-0pky">TransformerExt</td>
    <td class="tg-0pky">40.90</td>
    <td class="tg-0pky">18.02</td>
    <td class="tg-0pky">37.17</td>
  </tr>
  <tr>
    <td class="tg-0pky">BertSumExt</td>
    <td class="tg-0pky">43.23</td>
    <td class="tg-0pky">20.24</td>
    <td class="tg-0pky">39.63</td>
  </tr>
  <tr>
    <td class="tg-0pky">BertSumExt (large)</td>
    <td class="tg-0pky">43.85</td>
    <td class="tg-0pky">20.34</td>
    <td class="tg-0pky">39.90</td>
  </tr>
  <tr>
    <td class="tg-baqh" colspan="4">Abstractive</td>
  </tr>
  <tr>
    <td class="tg-0lax">TransformerAbs</td>
    <td class="tg-0lax">40.21</td>
    <td class="tg-0lax">17.76</td>
    <td class="tg-0lax">37.09</td>
  </tr>
  <tr>
    <td class="tg-0lax">BertSumAbs</td>
    <td class="tg-0lax">41.72</td>
    <td class="tg-0lax">19.39</td>
    <td class="tg-0lax">38.76</td>
  </tr>
  <tr>
    <td class="tg-0lax">BertSumExtAbs</td>
    <td class="tg-0lax">42.13</td>
    <td class="tg-0lax">19.60</td>
    <td class="tg-0lax">39.18</td>
  </tr>
</table>

**Python version**: This code is in Python3.7

## Trained Models
[CNN/DM BertExt](https://drive.google.com/open?id=1kKWoV0QCbeIuFt85beQgJ4v0lujaXobJ)

[CNN/DM BertExtAbs](https://drive.google.com/open?id=1-IKVCtc4Q-BdZpjXc4s70_fRsWnjtYLr)

[CNN/DM TransformerAbs](https://drive.google.com/open?id=1yLCqT__ilQ3mf5YUUCw9-UToesX5Roxy)

[XSum BertExtAbs](https://drive.google.com/open?id=1H50fClyTkNprWJNh10HWdGEdDdQIkzsI)


## Initialization
### 1. Setup Anaconda Environment
```
conda env create -f presumm.yml
conda activate jude_presumm
```

### 2. Prepare Pretrained Model
Copy `Presumm model` from this [link](https://drive.google.com/file/d/1-IKVCtc4Q-BdZpjXc4s70_fRsWnjtYLr/view)
Unzip it and put it in Presumm/models/ and name it as bertextabs.pt

### 3. Prepare Stanford CoreNLP Library
Run setup.sh


## Model Training

### Preprocessing
python dataset_to_stories.py convert <dataset> <train folder name>
```
python dataset_to_stories.py convert train_data_lesson_title.csv eva_train_04_27_2020
```

### Training
From base path, do the following:
```
cd src
```
./eva_train.sh <train folder name>
```
./eva_train.sh eva_train_04_27_2020
```

### Forecast
From base path, do the following:
```
cd src
```
./eva_forecast.sh <forecast folder name> <train folder name>
```
./eva_forecast.sh eva_forecast_04_27_2020 eva_train_04_27_2020
```

### Saving the Summaries
From base path, do the following:
```
cd src
```
python eva_summaries.py <forecast folder name> <forecasted lessons file>
```
python eva_summaries.py eva_forecast_04_27_2020 ulm_forecasts.csv
```
