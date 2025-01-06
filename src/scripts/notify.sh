#!/bin/bash

# Provide error if no webhook is set and error. Otherwise continue
if [ -z "${WEBHOOK}" ]; then
    echo "NO MS TEAMS WEBHOOK SET"
    echo "Please input your MSTEAMS_WEBHOOK value either in the settings for this project, or as a parameter for this orb."
    exit 1
fi

#If successful
if [ "$MSTEAMS_BUILD_STATUS" = "success" ]; then
    #Skip if fail_only
    if [ "${FAIL_ONLY}" = "1" ]; then
        echo "The job completed successfully"
        echo '"fail_only" is set to "true". No MS Teams notification sent.'
    else
        curl -X POST -H 'Content-type: application/json' \
            --data \
            "{ \
            \"type\": \"message\", \
            \"attachments\": [ \
                { \
                \"contentType\": \"application/vnd.microsoft.card.adaptive\", \
                \"contentUrl\": null, \
                \"content\": { \
                    \"\$schema\": \"http://adaptivecards.io/schemas/adaptive-card.json\", \
                    \"type\": \"AdaptiveCard\", \
                    \"version\": \"1.2\", \
                    \"body\": [
                    { \
                        \"type\": \"TextBlock\", \
                        \"size\": \"Medium\", \
                        \"weight\": \"Bolder\", \
                        \"color\": \"good\", \
                        \"text\": \"${SUCCESS_MESSAGE}\", \
                        \"wrap\": true \
                    }, \
                    { \
                        \"type\": \"FactSet\", \
                        \"facts\": [ \
                        { \
                            \"title\": \"Project\", \
                            \"value\": \"$CIRCLE_PROJECT_REPONAME\" \
                        }, \
                        { \
                            \"title\": \"Branch\", \
                            \"value\": \"$CIRCLE_BRANCH\" \
                        }, \
                        { \
                            \"title\": \"Pull Request Username\", \
                            \"value\": \"$CIRCLE_PR_USERNAME\" \
                        } \
                        ] \
                    } \
                    ], \
                    \"actions\": [ \
                    { \
                        \"type\": \"Action.OpenUrl\", \
                        \"title\": \"View Job\", \
                        \"url\": \"$CIRCLE_BUILD_URL\" \
                    }, \
                    { \
                        \"type\": \"Action.OpenUrl\", \
                        \"title\": \"View PR\", \
                        \"url\": \"$CIRCLE_PULL_REQUEST\" \
                    } \
                    ] \
                } \
                } \
            ] \
            }" "${WEBHOOK}"
        echo "Job completed successfully. Alert sent."
    fi
else
    #If Failed
    curl -X POST -H 'Content-type: application/json' \
    --data \
    "{ \
        \"type\": \"message\", \
        \"attachments\": [ \
        { \
            \"contentType\": \"application/vnd.microsoft.card.adaptive\", \
            \"contentUrl\": null, \
            \"content\": { \
            \"\$schema\": \"http://adaptivecards.io/schemas/adaptive-card.json\", \
            \"type\": \"AdaptiveCard\", \
            \"version\": \"1.2\", \
            \"body\": [
                { \
                \"type\": \"TextBlock\", \
                \"size\": \"Medium\", \
                \"weight\": \"Bolder\", \
                \"color\": \"warning\", \
                \"text\": \"${FAILURE_MESSAGE}\", \
                \"wrap\": true \
                }, \
                { \
                \"type\": \"FactSet\", \
                \"facts\": [ \
                    { \
                    \"title\": \"Project\", \
                    \"value\": \"$CIRCLE_PROJECT_REPONAME\" \
                    }, \
                    { \
                    \"title\": \"Branch\", \
                    \"value\": \"$CIRCLE_BRANCH\" \
                    }, \
                    { \
                    \"title\": \"Pull Request Username\", \
                    \"value\": \"$CIRCLE_PR_USERNAME\" \
                    } \
                ] \
                } \
            ], \
            \"actions\": [ \
                { \
                \"type\": \"Action.OpenUrl\", \
                \"title\": \"View Job\", \
                \"url\": \"$CIRCLE_BUILD_URL\" \
                }, \
                { \
                \"type\": \"Action.OpenUrl\", \
                \"title\": \"View PR\", \
                \"url\": \"$CIRCLE_PULL_REQUEST\" \
                } \
            ] \
            } \
        } \
        ] \
    }" "${WEBHOOK}"
    echo "Job failed. Alert sent."
fi
