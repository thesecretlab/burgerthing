import os
from flask import Flask, render_template, session, redirect, url_for, request
from flask.ext.script import Manager, Shell
from flask.ext.bootstrap import Bootstrap
from flask.ext.moment import Moment
from flask.ext.wtf import Form
from wtforms import StringField, SubmitField
from wtforms.validators import Required
from flask.ext.sqlalchemy import SQLAlchemy
import json

basedir = os.path.abspath(os.path.dirname(__file__))

app = Flask(__name__)
app.config['SECRET_KEY'] = '8tqwe7dsgicga796rg23bouqywf'
app.config['SQLALCHEMY_DATABASE_URI'] =\
    'sqlite:///' + os.path.join(basedir, 'data.sqlite')
app.config['SQLALCHEMY_COMMIT_ON_TEARDOWN'] = True
app.config['DEBUG'] = True

manager = Manager(app)
bootstrap = Bootstrap(app)
moment = Moment(app)
db = SQLAlchemy(app)

class Ingredient(db.Model):
    __tablename__ = 'ingredients'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(64), unique=True)
    
    def __repr__(self):
        return '<Ingredient %r>' % self.name


class Order(db.Model):
    __tablename__ = 'orders'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(64) , unique=False)
    ingredients = db.Column(db.String(256), unique=False)

    def __repr__(self):
        return '<Order %r (%r)>' % (self.name, self.ingredients)
        
@app.route('/')
def list_orders():
    orders = Order.query.all()
    return render_template('orders.html', orders=orders)
    
@app.route('/orders/new', methods=['POST'])
def create_orders():
    
    try:
        order = Order(name = request.form['name'], 
                      ingredients = request.form['ingredients'])
        db.session.add(order)
        db.session.commit()
    except Exception:
        msg = "Invalid order!"
        return json.dumps({"error": msg}), 400
    
    return json.dumps({"name":order.name, "ingredients":order.ingredients})

@app.route('/orders/delete/<order_id>')
def remove_order(order_id):
    
    order = Order.query.filter_by(id=order_id).first()
    
    if order is None:
        msg = "Order not found"
        return json.dumps({"error": msg}), 404
    
    db.session.delete(order)
    db.session.commit()
    
    return redirect(url_for('list_orders'))
    

@app.route('/orders.json')
def list_orders_json():
    orders = Order.query.all()
    
    json_orders = []
    
    for order in orders:
        d = {
            "name": order.name,
            "ingredients": order.ingredients
        }
        json_orders.append(d)
    
    return json.dumps({"orders":json_orders})
    

@app.route('/ingredients')
def list_ingredients():
    ingredients = Ingredient.query.all()
    return render_template('ingredients.html', ingredients=ingredients)

@app.route('/ingredients.json')
def list_ingredients_json():
    ingredients = Ingredient.query.all()
    
    json_ingredients = []
    
    for ingredient in ingredients:
        d = {
            "name": ingredient.name
        }
        json_ingredients.append(d)
    
    return json.dumps({"ingredients":json_ingredients})
    

if __name__ == '__main__':
    manager.run()
