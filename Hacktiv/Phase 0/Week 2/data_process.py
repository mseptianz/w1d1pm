import pandas as pd
import sys

class DataProcessor:
    def __init__(self, file_path):
        self.file_path = file_path
        self.df = None

    def load_data(self):
        self.df = pd.read_csv(self.file_path).reset_index()

    def clean_data(self):

        #Rename Commision (in value) Column
        self.df.rename({'Commision (in value)':'Commision'},axis=1,inplace=True)

        #Take out Gender Column
        self.df.drop(columns='Gender',inplace=True)

        # Drop duplicates
        self.df.drop_duplicates(inplace=True)

    def simple_query(self, column, value):
        return self.df[self.df[column]==value].drop(columns='index')

    def summary(self,cols=[],aggs={}):
        self.tmp = self.df.groupby(cols).agg(aggs).reset_index()
        self.renames = dict()
        for col,agg in aggs.items():
            self.renames[col] = f'{agg} {col}'.title()

        return self.tmp.rename(self.renames,axis=1)


    def save_data(self, output_file_path, data, sheet_names):
        with pd.ExcelWriter(output_file_path) as writer:
            self.df.to_excel(writer, sheet_name='Complete', index=False)
            for i,dat in enumerate(data):
              try:
                dat.to_excel(writer, sheet_name=sheet_names[i], index=False)
              except:
                display(dat)
                print(i)


if __name__ == "__main__":
    input_file = sys.argv[2]
    output_file = sys.argv[4]

    print("Data Processing Script Started...")

    # Create an instance of DataCleaning
    proc = DataProcessor(file_path=input_file)

    # Load data
    print("Loading data...")

    try:
      proc.load_data()
    except Exception as e:
      print('Error has occured while loading the data')
      print(e)
      print('Cannot be Continued')
      print('Stop')
      sys.exit()


    # Clean data
    print("Cleaning data...")
    proc.clean_data()

    # Preprocess data
    print("Preprocessing data...")
    ol = proc.simple_query('Distribution Channel','Online')
    of = proc.simple_query('Distribution Channel','Offline')
    sum = proc.summary(cols=['Destination','Agency Type','Distribution Channel','Claim'],
              aggs={'index':'count','Duration':'mean','Net Sales':'max','Commision':'sum','Age':'mean'})

    # Save cleaned data
    print("Saving cleaned data...")

    proc.save_data(output_file,data=[ol,of,sum], sheet_names=['Online','Offline','Countries Summary'])

    print("Data Processing Script Completed!")
