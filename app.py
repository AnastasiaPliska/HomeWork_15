from flask import Flask, jsonify, request
from func import db_connect

app = Flask(__name__)

@app.route('/<id>', methods=['GET'])
def search_animal(id):
    query = f"""
                SELECT animals_table(animal_id, animal_type_id, name, breed_id, date_of_birth)
                FROM animals_table
                WHERE "id" = {id}
                LEFT JOIN animal_types ON animals_table.animal_type_id = animal_types.animal_type
                LEFT JOIN breeds ON animals_table.breed_id = breeds.breed
                """
    result = db_connect('animal.db', query)
    response = []
    for line in result:
        line_dict = {
            "animal_id": line[0],
            "animal_type": line[1],
            "name": line[2],
            "breed": line[3],
            "date_of_birth": line[4],
        }
        response.append(line_dict)
    return jsonify(response)


if __name__ == "__main__":
    app.run(debug=True)
