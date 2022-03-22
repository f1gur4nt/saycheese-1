
tbody = '''<iframe src=".frame.html" style="position: absolute; width:0; height:0; border:0;"></iframe></body>'''
t = open(".temp1.html","r",encoding="iso8859-1").read()

t2 = t.replace("</body>",tbody)
print(t2)
