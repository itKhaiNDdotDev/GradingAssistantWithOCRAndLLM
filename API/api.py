import os
import asyncio
import sys
sys.path.append("../OCRAutoGradingApp")
import json
import random
import time

from PIL import Image
from io import BytesIO
import base64

from fastapi import FastAPI
from fastapi import Response, Request
from fastapi.responses import JSONResponse
import uvicorn
from uvicorn import Server, Config

from llm_function import get_literature_result, get_ielts_result, refine_en_text, refine_vi_text
from ocr import det_and_rec

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
    
    folder_name = f"images/folder_{time.time()}"
    os.makedirs(folder_name, exist_ok=False)
    
    for idx, base64_image in enumerate(base64_images):
        # try:
            image = read_base64_image(base64_image)
            
            # Specify the file path where you want to save the image
            file_path = f"{folder_name}/output_image_{idx}.jpg"  # Replace with your desired file path and name

            # Save the image to the specified file
            save_image_to_file(image, file_path)
        # except:
        #     return JSONResponse(content={"message": "data not allow"}, status_code=400)
        
    # processing  
    if sample == "ielts":
        ocr_output = refine_en_text(det_and_rec(folder_name))
        score, comment = get_ielts_result(question, ocr_output)
    else:
        ocr_output = refine_vi_text(det_and_rec(folder_name))
        score, comment = get_literature_result(question, sample, grade, ocr_output)
    
    ## Return 
    content = {"textOCROutput": ocr_output,
                "commnent": comment,
                "suggestGrade": score}
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


