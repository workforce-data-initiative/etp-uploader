FROM python
WORKDIR uploader
ADD requirements requirements
ADD requirements.txt requirements.txt
RUN pip install -r requirements.txt
ADD . .
ENV PORT=5000
EXPOSE 5000
CMD [ "python", "main.py" ]
