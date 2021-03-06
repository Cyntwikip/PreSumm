import pandas as pd
import glob, re, os
import click

def split_lines(text):
    text = [' '.join(i.split()) for i in re.split(r'\n{2,}', text)]
    text = [i for i in text if i]
    return text

def get_num(txt):
    return int(re.findall(r'\d+', txt)[0])

def get_ref(txt):
    return int(re.findall(r'\d+', txt)[1])

def merge_and_get_summaries(forecast_path, forecasted_lessons_file):
#     forecast_path = 'eva_forecast_02_21_2020'
#     forecasted_lessons_file = '~/notebooks/Cognitive_Search/sash/data/feb_20/ulm_forecasts.csv'
    steps = 1000
    file = f'{forecast_path}.log.{148000+steps}'
#     path = '/data/home/admin01//notebooks/Jude/Presumm2/PreSumm/logs/'
    path = 'logs/'
    path = os.path.join(path, file)

    results = {}
    for suffix in ['gold', 'raw_src', 'candidate']:
        with open(f'{path}.{suffix}', 'r') as f:
            results[suffix] = f.readlines()

    df_gen = pd.DataFrame({'human-generated': results['gold'], 'machine-generated': results['candidate']})
    df_gen['lesson_num'] = df_gen['human-generated'].apply(get_num)
    df_gen['ref_id'] = df_gen['human-generated'].apply(get_ref)

    df = pd.read_csv(forecasted_lessons_file, usecols=[1,2,4,5])
    df['reference_id'] = df['reference_id'].apply(lambda x: 0 if x!=x else x).astype(int)
    df = df.where(df['isLesson']==1).dropna()
    df.drop('isLesson', axis=1, inplace=True)
    df['paragraph'] = df['paragraph'].apply(split_lines)
    df = df.reset_index(drop=True)
    df['reference_id'] = df['reference_id'].astype(int)
    df['lesson_num'] = df.index
    df.rename(columns={'Project Number':'project_number'}, inplace=True)

    df_merged = df[['paragraph','reference_id','project_number','lesson_num']].merge(
                    df_gen[['machine-generated','lesson_num']], on='lesson_num')
    
    df_merged.to_csv(f'{forecast_path}.csv')
    
    return

@click.group()
def cli():
    pass

@cli.command()
@click.argument('forecast_path')
@click.argument('forecasted_lessons_file')
def get_summaries(forecast_path, forecasted_lessons_file):
    merge_and_get_summaries(forecast_path, forecasted_lessons_file)
    return

if __name__=='__main__':
    cli()
            
