# Lambda Layer for Node.js Libraries
When your Lambda need to import libraries, packaing all libraries along with your business logic is not recommended.  Instead you can upload libraries as Lambda Layers, so that multiple Lambda functions can access libray from a common location (layer).  

This module will create an AWS Lambda Layer with ANY nodejs library you like.   This module is published in Terraform as [**TechieInYou/lambdalayer-nodejs/aws**](https://registry.terraform.io/modules/techieinyou/lambdalayer-nodejs/aws/latest). 

## How this module works?
You can assign the name of library you want to install in the variable __library_name__ .  

Once you provide the library name, this module will

    1. create a local folder `lambdalayer` 
    2. install the library (using npm) in the above folder
    3. after succussfull installation, it will package the folder
    4. create a Lambda Layer in AWS and will upload the package
    5. return the ARN of the Lambda Layer with version #


## Other Variables can be assigned 

### Layer Name (Optional)
You can assign the Lambda Layer name by assigning variable __layer_name__.  If not provided, then the layer name will be **lib-nodejs-"library-name"**.  


### Node.js Runtime (Optional)
This module supports the following Node.js runtimes.  

| Version     | Identifier |	
|-------------|----------- |
| Node.js 20  | nodejs20.x |
| Node.js 18  | nodejs18.x |
| Node.js 16  | nodejs16.x |

You can change the runtime by assigning variable __nodejs_runtime__.  If not provided, Layer will be created with latest runtime __nodejs20.x__