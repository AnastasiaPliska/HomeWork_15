from flask import Flask, jsonify
from func import db_connect

app = Flask(__name__)

@app.route('/<id>', methods=['GET'])
def search_animal(id):
    query = f"""
                SELECT animal_id, animal_type_id, name, breed_id, date_of_birth
                FROM animals_table
                WHERE "id" = {id}
                """
    result = db_connect('animal.db', query)
    response = []
    for line in result:
        line_dict = {
            "animal_id": line[0],
            "animal_type_id": line[1],
            "name": line[2],
            "breed_id": line[3],
            "date_of_birth": line[4],
        }
        response.append(line_dict)
    return jsonify(response)


if __name__ == "__main__":
    app.run(debug=True)
