import asyncio
import sys
import json

from PIL import Image
from io import BytesIO
import base64

from fastapi import FastAPI
from fastapi import Response, Request
from fastapi.responses import JSONResponse
import uvicorn
from uvicorn import Server, Config

########################################
############# FUNCTION #################
########################################

def read_base64_image(base64_string):
    # Decode the base64 string to bytes
    image_data = base64.b64decode(base64_string)
    
    # Create a BytesIO object and load the image data
    img_stream = BytesIO(image_data)
    
    # Open the image using PIL
    img = Image.open(img_stream)
    
    return img

def save_image_to_file(img, file_path):
    # Save the image to a file
    img.convert('RGB').save(file_path)

## app

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.post("/get_result")
async def get_result(request: Request):
    data = await request.json()
    question = data["question"]
    sample = data["sample"]
    grade = data["grade"]
    base64_images = data["images"]
    
    for base64_image in base64_images:
        try:
            image = read_base64_image(base64_image)
            
            # Specify the file path where you want to save the image
            file_path = f"images/output_image_{base64_image[:10]}.jpg"  # Replace with your desired file path and name

            # Save the image to the specified file
            save_image_to_file(image, file_path)
        except:
            return JSONResponse(content={"message": "data not allow"}, status_code=400)
    
    ## Return 
    content = {"textOCROutput": "Kết quả đầu ra từ OCR đã qua chọn lọc xử lý các đoạn trùng để ở đây (bài làm dạng text)",
                "commnent": f"{question}, {sample}, {grade}",
                "suggestGrade": 5.25}
    return  JSONResponse(content=content)

##########################################
############### RUN APP ##################
##########################################

class MyServer(Server):
    async def run(self, sockets=None):
        self.config.setup_event_loop()
        return await self.serve(sockets=sockets)

configList=[
    {
        'app' : 'api:app',
        'port' : 59815
    },
    
]

async def create_webserver(app, port):
    server_config = Config(app, port=port, host='localhost',log_level="info", reload=True)
    server = Server(server_config)
    await server.serve()

# @profile
async def main():
    done, pending = await asyncio.wait(
        [
            create_webserver(cfg['app'], cfg['port']) for cfg in configList
        ],
        return_when=asyncio.FIRST_COMPLETED,
    )
    print("done")
    print(done)
    print("pending")
    print(pending)
    for pending_task in pending:
        pending_task.cancel("Another service died, server is shutting down")


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except Exception as e:
        print(e)
        sys.exit(0)


