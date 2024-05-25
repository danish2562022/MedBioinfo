import sqlite3
import csv


db = '/proj/applied_bioinformatics/users/x_daanw/MedBioinfo/analyses/sample_collab.db'

conn = sqlite3.connect(db)
cursor = conn.cursor()

cursor.execute('select * from sample2bioinformatician limit 2;')
rows = cursor.fetchall()
for row in rows:
    print(row)

#'''cursor.execute('''
  #  INSERT INTO bioinformaticians (username, firstname, lastname)
 #   VALUES ('x_daanw','danish', 'anwer')
#''')
conn.commit()
cursor.execute('select * from bioinformaticians limit 20;')
rows = cursor.fetchall()
for row in rows:
    print(row)

query = '''
SELECT *
FROM sample_annot
LEFT JOIN sample2bioinformatician
ON sample_annot.patient_code = sample2bioinformatician.patient_code ORDER BY username LIMIT 5;
'''
cursor.execute(query)
rows = cursor.fetchall()
for row in rows:
    print(row)
'''
rows_to_insert = [
    ('x_daanw', 'P11'),
    ('x_daanw', 'P19'),
    ('x_daanw', 'P69'),
    ('x_daanw', 'P90'),
    ('x_daanw', 'P267'),
    # Add more rows as needed
]
#insert_query = '''
 #   INSERT INTO Sample2bioinformatician(username, patient_code)
 #   VALUES (?, ?)
'''
cursor.executemany(insert_query, rows_to_insert)
conn.commit()
'''

cursor.execute('select * from sample2bioinformatician limit 20;')
rows = cursor.fetchall()
for row in rows:
    print(row)


cursor.execute("select run_accession from sample_annot spl left join sample2bioinformatician s2b using(patient_code) where username='x_daanw';")
rows = cursor.fetchall()
output_csv_path = '/proj/applied_bioinformatics/users/x_daanw/MedBioinfo/analyses/x_daanw_run_accessions.txt'
with open(output_csv_path, mode='w', newline='') as file:
    writer = csv.writer(file)
    writer.writerows(rows)
conn.commit()
rows = cursor.fetchall()
for row in rows:
    print(row)
