resource "genesyscloud_integration_action" "action" {
    name           = var.action_name
    category       = var.action_category
    integration_id = var.integration_id
    secure         = var.secure_data_action
    
    contract_input  = jsonencode({
        "$schema": "http://json-schema.org/draft-04/schema#",
        "description": "A phone number-based request.",
        "properties": {
            "PHONE_NUMBER": {
                "description": "The phone number used for the query.",
                "type": "string"
            }
        },
        "required": [
            "PHONE_NUMBER"
        ],
        "title": "Phone Number Request",
        "type": "object"
    })
    contract_output = jsonencode({
        "$schema": "http://json-schema.org/draft-04/schema#",
        "items": {
            "$schema": "http://json-schema.org/draft-04/schema#",
            "description": "A Microsoft Dynamics 365 contact.",
            "properties": {
                "_owninguser_value": {
                    "description": "The ID of the system user who owns the contact.",
                    "type": "string"
                },
                "_parentcustomerid_value": {
                    "description": "The parent account ID.",
                    "type": "string"
                },
                "address1_city": {
                    "description": "Address 1 city.",
                    "type": "string"
                },
                "address1_country": {
                    "description": "Address 1 country.",
                    "type": "string"
                },
                "address1_line1": {
                    "description": "Address 1 line 1 of the street address.",
                    "type": "string"
                },
                "address1_line2": {
                    "description": "Address 1 line 2 of the street address.",
                    "type": "string"
                },
                "address1_postalcode": {
                    "description": "Address 1 postal code.",
                    "type": "string"
                },
                "address1_stateorprovince": {
                    "description": "Address 1 state or province.",
                    "type": "string"
                },
                "emailaddress1": {
                    "description": "Email address 1 for the contact.",
                    "type": "string"
                },
                "emailaddress2": {
                    "description": "Email address 2 for the contact.",
                    "type": "string"
                },
                "emailaddress3": {
                    "description": "Email address 3 for the contact.",
                    "type": "string"
                },
                "firstname": {
                    "description": "The first name of the contact.",
                    "type": "string"
                },
                "lastname": {
                    "description": "The last name of the contact.",
                    "type": "string"
                },
                "leadid": {
                    "description": "The ID of the contact.",
                    "type": "string"
                },
                "mobilephone": {
                    "description": "Mobile phone number for the contact.",
                    "type": "string"
                },
                "nickname": {
                    "description": "The nickname of the contact.",
                    "type": "string"
                },
                "telephone1": {
                    "description": "Phone number 1 for the contact.",
                    "type": "string"
                },
                "telephone2": {
                    "description": "Phone number 2 for the contact.",
                    "type": "string"
                },
                "telephone3": {
                    "description": "Phone number 3 for the contact.",
                    "type": "string"
                }
            },
            "required": [
                "leadid"
            ],
            "title": "Contact",
            "type": "object"
        },
        "properties": {},
        "type": "array"
    })
    
    config_request {
        request_template     = "$${input.rawRequest}"
        request_type         = "GET"
        request_url_template = "/api/data/v8.1/leads?$${esc.dollar}select=leadid,_owninguser_value,firstname,lastname,telephone1,telephone2,telephone3,mobilephone,emailaddress1,emailaddress2,emailaddress3,address1_line1,address1_line2,address1_city,address1_stateorprovince,address1_postalcode,address1_country,createdon&$${esc.dollar}orderby=$esc.url(\"createdon desc\")&$${esc.dollar}top=1&$${esc.dollar}filter=$esc.url($msdynamics.phoneNumberFilter(\"$input.PHONE_NUMBER\", [\"telephone1\", \"telephone2\", \"telephone3\", \"mobilephone\"]))"
        headers = {
			UserAgent = "PureCloudIntegrations/1.0"
		}
    }

    config_response {
        success_template = "$${contact}"
        translation_map = { 
			contact = "$.value"
		}
    }
}