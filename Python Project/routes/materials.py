from flask import Blueprint, request, jsonify
from models import db, Material
from werkzeug.exceptions import BadRequest

materials_bp = Blueprint('materials', __name__)

@materials_bp.route('/materials', methods=['GET'])
def get_materials():
    materials = Material.query.all()
    return jsonify([{
        'materialId': mat.material_id,
        'Material name': mat.name,
        'count': mat.count
    } for mat in materials])

@materials_bp.route('/materials', methods=['POST'])
def add_material():
    try:
        data = request.get_json()

        new_material = Material(
            material_id=data['materialId'],
            name=data['Material name'],
            count=data['count']
        )
        
        db.session.add(new_material)
        db.session.commit()
        
        return jsonify({
            "message": "Материал добавлен",
            "id": new_material.material_id
        }), 201
        
    except BadRequest as e:
        return jsonify({"error": str(e)}), 400
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500

@materials_bp.route('/materials/<int:material_id>', methods=['PUT'])
def update_material(material_id):
    material = Material.query.get_or_404(material_id)
    data = request.get_json()
    
    try:
        if 'Material name' in data:
            material.name = data['Material name']
        if 'count' in data:
            material.count = data['count']
            
        db.session.commit()
        return jsonify({"message": "Материал обновлен"})
    
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500

@materials_bp.route('/materials/<int:material_id>', methods=['DELETE'])
def delete_material(material_id):
    material = Material.query.get_or_404(material_id)
    
    try:
        db.session.delete(material)
        db.session.commit()
        return jsonify({"message": "Материал удален"})
    
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500