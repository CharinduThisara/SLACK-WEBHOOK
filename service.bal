import ballerina/http;
import ballerinax/slack;
import ballerina/io;
import ballerina/log;
import ballerina/regex;

type SlackConfig record {
    string authToken;
    string channelName;
    
};

public type Message record {|
    string text;
|};

type output record {
    string message;
};


configurable SlackConfig config = ?;

// Slack client configuration
slack:ConnectionConfig slackConfig = {
    auth: {
        token: config.authToken
    }
};

// Creating a Slack client
slack:Client slackClient = check new(slackConfig);

// A service representing a network-accessible API bound to port `9090`
service /slack\-api on new http:Listener(9090) {
    resource function post sendMessageToSlack(Message msg) returns string|error? {

        io:println(msg.text);
       
        slack:Message message = {
            channelName: config.channelName,
            text: msg.text,

            blocks: [   
                {
                    "type": "section",
                    "text": {
                        "type": "mrkdwn",
                        "text": "Support Ticket:\n*"
                    }
                },
                {
                    "type": "section",
                    "fields": [
                        {
                            "type": "mrkdwn",
                            "text": "*Created:*\n " 
                        },
                        {
                            "type": "mrkdwn",
                            "text": "*NIC:*\n " 
                        }
                    ]
                },
                {
                    "type": "section",
                    "text": {
                        "type": "mrkdwn",
                        "text": "*Description*:\n"
                    }
                },
                {
                    "type": "actions",
                    "elements": [
                        {
                            "type": "button",
                            "text": {
                                "type": "plain_text",
                                "emoji": true,
                                "text": "Message"
                            },
                            "style": "primary",
                            "value": "click_me_123"
                        },
                        {
                            "type": "button",
                            "text": {
                                "type": "plain_text",
                                "emoji": true,
                                "text": "Discard"
                            },
                            "style": "danger",
                            "value": "www.google.com"
                        }
                    ]
                }
            ]
        };
        
        string|error messageResponse = slackClient->postMessage(message);
        if (messageResponse is error) {
            log:printError(string `Slack Message Failed: ${messageResponse.toString()}`);
            return messageResponse;
        } else {
            log:printInfo(string `Slack Message Success: ${messageResponse}`);
            string msgUrl = regex:replaceAll(messageResponse, "\\.", "");
            // msgUrl = string `https://zetcco.slack.com/messages/C05NBLBQGHW/p${msgUrl}`;
            return msgUrl;
        }
    }
}

//     resource function put updateSlackMessage(http:Caller caller, http:Request req) returns json|error {
//         // Your implementation to update a message in Slack
//         // Extract necessary data from the request payload and update the message

//         // For demonstration purposes, this code assumes the message details and timestamp are sent in the request payload
//         var payload = check req.getJsonPayload();
//         string channel = check payload.channel;
//         string text = check payload.text;
//         string timestamp = check payload.timestamp; // Message timestamp

//         slack:Message message = {
//             channelName: channel,
//             text: text,
//             timestamp: timestamp
//         };

//         string|error updateResponse = slackClient->updateMessage(message);

//         if (updateResponse is error) {
//             return { "error": updateResponse.reason() };
//         } else {
//             return { "message": "Message updated successfully" };
//         }
//     }

    // Endpoint to delete a Slack message
   
//     resource function delete deleteSlackMessage(http:Caller caller, http:Request req) returns json|error {
//         // Your implementation to delete a message in Slack
//         // Extract necessary data from the request payload and delete the message

//         // For demonstration purposes, this code assumes the timestamp of the message to be deleted is sent in the request payload
//         var payload = check req.getJsonPayload();
//         string channel = check payload.channel;
//         string timestamp = check payload.timestamp; // Message timestamp

//         // slack:Message message = {
//         //     channelName: channel,
//         //     timestamp: timestamp
//         // };

//         string|error deleteResponse = slackClient->deleteMessage(message);

//         if (deleteResponse is error) {
//             return { "error": deleteResponse.reason() };
//         } else {
//             return { "message": "Message deleted successfully" };
//         }
//     }
// }

//     // Endpoint to list Slack channels
//     @http:ResourceConfig {
//         methods: ["GET"],
//         path: "/list-channels"
//     }
//     resource function listSlackChannels(http:Caller caller, http:Request req) returns json|error {
//         // Your implementation to list channels in Slack

//         slack:ChannelListResponse|error channelsResponse = slackClient->listChannels();

//         if (channelsResponse is error) {
//             return { "error": channelsResponse.reason() };
//         } else {
//             return channelsResponse;
//         }
//     }

//     // Endpoint to upload a file to Slack
//     @http:ResourceConfig {
//         methods: ["POST"],
//         path: "/upload-file"
//     }
//     resource function uploadFileToSlack(http:Caller caller, http:Request req) returns json|error {
//         // Your implementation to upload a file to Slack
//         // Extract necessary data from the request payload and upload the file
        
//         // For demonstration purposes, this code assumes file details are sent in the request payload
//         var payload = check req.getJsonPayload();
//         string channel = check payload.channel;
//         string filePath = check payload.filePath;

//         slack:FileUploadResponse|error fileUploadResponse = slackClient->uploadFile(channel, filePath);

//         if (fileUploadResponse is error) {
//             return { "error": fileUploadResponse.reason() };
//         } else {
//             return fileUploadResponse;
//         }
//     }
// }
