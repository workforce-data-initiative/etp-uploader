from web import factory
from web.config import default

application = factory.create_app(default)
if __name__ == "__main__":
    application.run(debug=True)
