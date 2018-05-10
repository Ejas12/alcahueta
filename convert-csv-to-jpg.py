import cloudconvert
import os
import sys
csvfilename = sys.argv[1]
#pngfilename = sys.argv[2]


api = cloudconvert.Api('yB9ARwi0NYNYCv8vaTMNNpFsONtr74MhnRRSUBo_U6fo8Q8pFbszVVi20Z5s654zrGuIzg_iUj0FhG-MWdmRBQ')
 
process = api.convert({
    "inputformat": "csv",
    "outputformat": "png",
    "input": "upload",
    "output": {
        "s3": {
            "accesskeyid": "AKIAJ4BDNMVSURFNJSTQ",
            "secretaccesskey": "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",
            "bucket": "liftinglistsnaps",
            "region": "us-west-2",
            "acl": "public-read",
            "Metadata": {
                "Content-Disposition":"attachment"
                }
        }
    },
    "file": open(os.fspath(csvfilename), 'rb')
})
process.wait()
