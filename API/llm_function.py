import re
import openai
openai.api_key = "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"


def get_literature_result(question, barem, max_point, answer):
    system = """Đóng vai trò là một Bạn là một giáo viên cực kỳ nghiêm khắc, hay trừ điểm học sinh. Hãy đưa ra những phản hồi cụ thể, mang tính xây dựng, khách quan. Cho điểm của học sinh dựa trên barem điểm sẽ được cung cấp. Hãy trả lời theo mẫu: Điểm số: Nhận xét: """
    user = """Đề bài như sau: "{}"\nBarem điểm:  \n"Số điểm tối đa {} điểm \n{}" \nHãy chấm điểm bài viết sau: "{}" """
    # make prompt
    prompt = {"messages": [{"role": "system",
                            "content": system},
                            {"role": "user",
                            "content": user.format(question, max_point, barem, answer)}]}
                        #    {"role": "assistant",
                        #     "content": assistant.format(band, comment)}]}
    # write to file
    completion = openai.ChatCompletion.create(
        model="gpt-3.5-turbo-0613",
        messages=prompt["messages"],
        request_timeout=60
    )
    output = completion.choices[0].message["content"]
    
    feedback_text = output

    # Tìm kiếm và tách điểm số và nhận xét bằng regex
    match = re.search(r"Điểm số: (.+?) điểm\nNhận xét: (.+)", feedback_text, re.DOTALL)

    if match:
        diem_so = match.group(1)
        nhan_xet = match.group(2)
    else:
        print("error")
        return 0.0, feedback_text
    try:
        return float(diem_so), nhan_xet
    except:
        return 0.0, feedback_text
    
def get_ielts_result(question, essay):
    system = """Imagine you are an ielts examiner. You have been provided an IELTS task and a candidate's essay. Please evaluate and give the essay apporiate band along with detail feedback explanation according to these criterias: COHERENCE AND COHESION, LEXICAL RESOURCE, GRAMMATICAL RANGE, TASK ACHIEVEMENT. Please give by format: Band: Feedback:"""
    user = """Question: {}\nEssay: {}"""
    # make prompt
    prompt = {"messages": [{"role": "system",
                            "content": system},
                            {"role": "user",
                            "content": user.format(question, essay)}]}
                        #    {"role": "assistant",
                        #     "content": assistant.format(band, comment)}]}
    # write to file
    completion = openai.ChatCompletion.create(
        model="ft:gpt-3.5-turbo-0613:abcd::8Dseh4EP",
        messages=prompt["messages"],
        request_timeout=60
    )
    output = completion.choices[0].message["content"]
    
    feedback_text = output

    # Tìm kiếm và tách phần Band và Feedback bằng regex
    match = re.search(r"Band: (.+?)\nFeedback: (.+)", feedback_text, re.DOTALL)

    if match:
        band = match.group(1)
        feedback = match.group(2)

        # print("Band:", band)
        # print("\nFeedback:", feedback)
    else:
        print("error")
        return 0.0, feedback_text
    try:
        return float(band), feedback
    except:
        return 0.0, feedback_text
    

def refine_vi_text(input_text):
    system = """Bạn là một người thông thạo tiếng việt, có khả năng sửa lỗi chính tả một cách tỉ mỉ và làm cho những câu văn trở nên sáng nghĩa, dễ hiểu đối với người việt. Hãy sửa lỗi chính tả đoạn chữ sau"""
    user = """{}"""
    # make prompt
    prompt = {"messages": [{"role": "system",
                            "content": system},
                            {"role": "user",
                            "content": user.format(input_text)}]}
                        #    {"role": "assistant",
                        #     "content": assistant.format(band, comment)}]}
    # write to file
    completion = openai.ChatCompletion.create(
        model="gpt-3.5-turbo-0613",
        messages=prompt["messages"],
        request_timeout=60
    )
    output = completion.choices[0].message["content"]
    
    return output

def refine_en_text(input_text):
    system = """You are a person fluent in English, capable of meticulously correcting spelling errors and making sentences clear and understandable to English people. Please correct the spelling of the following text"""
    user = """{}"""
    # make prompt
    prompt = {"messages": [{"role": "system",
                            "content": system},
                            {"role": "user",
                            "content": user.format(input_text)}]}
                        #    {"role": "assistant",
                        #     "content": assistant.format(band, comment)}]}
    # write to file
    completion = openai.ChatCompletion.create(
        model="gpt-3.5-turbo-0613",
        messages=prompt["messages"],
        request_timeout=60
    )
    output = completion.choices[0].message["content"]
    
    return output
    
    