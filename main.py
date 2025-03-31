import psycopg2
from configparser import ConfigParser
from datetime import datetime
import random

def load_config(filename='database.ini', section='postgresql'):
    parser = ConfigParser()
    parser.read(filename)

    config = {}
    if parser.has_section(section):
        params = parser.items(section)
        for param in params:
            config[param[0]] = param[1]
    else:
        raise Exception('Section {0} not found in the {1} file'.format(section, filename))

    return config

def insert_dummy(times):
    """ Connect to the PostgreSQL database server """

    dummy_products = ['Laptop', 'Smartphone', 'Fridge', 'Monitor', 'TV']

    sql = """INSERT INTO orders (product_name, quantity, order_date)
            VALUES(%s, %s, %s);"""

    config = load_config()        
    
    try:
        with psycopg2.connect(**config) as conn:
            with  conn.cursor() as cur:
                for _ in range(times):
                    cur.execute(
                            sql,
                                (random.choice(dummy_products),
                                str(random.randrange(1,10)),
                                datetime.today().strftime('%Y-%m-%d')
                            )
                        )
                
                conn.commit()

    except (psycopg2.DatabaseError, Exception) as error:
        print(error)

def main():
    insert_dummy(5)
    print("Inserted!")


if __name__ == "__main__":
    main()
