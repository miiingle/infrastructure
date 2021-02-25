var synthetics = require('Synthetics');
const log = require('SyntheticsLogger');

const apiCanaryBlueprint = async function () {

    // Handle validation for positive scenario
    const validateSuccessfull = async function(res) {
        return new Promise((resolve, reject) => {
            if (res.statusCode < 200 || res.statusCode > 299) {
                throw res.statusCode + ' ' + res.statusMessage;
            }

            let responseBody = '';
            res.on('data', (d) => {
                responseBody += d;
            });

            res.on('end', () => {
                // Add validation on 'responseBody' here if required.
                resolve();
            });
        });
    };


    // Set request option for Health Check
    let requestOptionsStep1 = {
        hostname: 'dev.api.miiingle.net',
        method: 'GET',
        path: '/health',
        port: '443',
        protocol: 'https:',
        body: "",
        headers: {}
    };
    requestOptionsStep1['headers']['User-Agent'] = [synthetics.getCanaryUserAgentString(), requestOptionsStep1['headers']['User-Agent']].join(' ');

    // Set step config option for Health Check
    let stepConfig1 = {
        includeRequestHeaders: false,
        includeResponseHeaders: false,
        includeRequestBody: false,
        includeResponseBody: false,
        restrictedHeaders: [],
        continueOnHttpStepFailure: true
    };

    await synthetics.executeHttpStep('Health Check', requestOptionsStep1, validateSuccessfull, stepConfig1);


};

exports.handler = async () => {
    return await apiCanaryBlueprint();
};