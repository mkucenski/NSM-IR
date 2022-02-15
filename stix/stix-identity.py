#!/usr/bin/env python3

import argparse
from stix2 import Identity, \
						FileSystemSink

identity_class_choices = ['individual', 'group', 'system', 'organization', 'class', 'unknown']

identity_sector_choices = ['agriculture', 'aerospace', 'automotive', 'chemical', 'commercial', 'communications', 'construction', 'defense',
									'education', 'energy', 'entertainment', 'financial-services', 'government', 'healthcare', 'hospitality-leisure',
									'infrastructure', 'insurance', 'manufacturing', 'mining', 'non-profit', 'pharmaceuticals', 'retail', 'technology',
									'telecommunications', 'transportation', 'utilities']

arg_parser = argparse.ArgumentParser()

# Identity Properties
arg_parser.add_argument("-n", "--name", required = True, \
								help = '"The name of this Identity. When referring to a specific entity (e.g., an individual or organization), ' \
								'this property SHOULD contain the canonical name of the specific entity."')
arg_parser.add_argument("-d", "--description", \
								help = '"A description that provides more details and context about the Identity, potentially including its ' \
								'purpose and its key characteristics."')
arg_parser.add_argument("-r", "--role", action = 'append', \
								help = '"The list of roles that this Identity performs (e.g., CEO, Domain Administrators, Doctors, Hospital, or ' \
								'Retailer). No open vocabulary is yet defined for this property."')
arg_parser.add_argument("-c", "--class", choices = identity_class_choices, metavar = "IDENTITY CLASS", \
								help = "{" + ", ".join(identity_class_choices) + "}")
arg_parser.add_argument("-s", "--sector", choices = identity_sector_choices, metavar = "IDENTITY SECTOR", action = 'append', \
								help = "{" + ", ".join(identity_sector_choices) + "}")
arg_parser.add_argument("-e", "--contactInfo", \
								help = '"The contact information (e-mail, phone number, etc.) for this Identity. No format for this information ' \
								'is currently defined by this specification."')

# Other Options
arg_parser.add_argument("-o", "--outputdir", help = "")
arg_parser.add_argument('--version', action = 'version', version = '%(prog)s 1.0')

args = vars(arg_parser.parse_args())

object = Identity(	type = "identity",
							name = args['name'],
							description = args['description'],
							roles = args['role'],
							identity_class = args['class'],
							sectors = args['sector'],
							contact_information = args['contactInfo'])
print(object.serialize(pretty = True))

if args['outputdir']:
	fs_sink = FileSystemSink(args['outputdir'])
	fs_sink.add(object)

