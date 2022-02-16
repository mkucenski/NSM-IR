#!/usr/bin/env python3

version = "1.0"

import argparse
from stix2 import Indicator, \
						ExternalReference, \
						FileSystemSink, \
						Note, \
						KillChainPhase

type_choices = ['anomalous-activity', 'anonymization', 'benign', 'compromised', 'malicious-activity', 'attribution', 'unknown']

tactic_choices = ['reconnaissance', 'resource-development', 'initial-access', 'execution', 'persistence', 'privilege-execution', 
						'defense-evasion', 'credential-access', 'discovery', 'command-control', 'exfiltration', 'impact']

pattern_ref_url = "https://docs.oasis-open.org/cti/stix/v2.1/os/stix-v2.1-os.html#_mlbmudhl16lr"
pattern_objects = [	'artifact', 'autonomous-system', 'directory', 'domain-name', 'email-addr', 'file', 'ipv4-addr',
							'ipv6-addr', 'mac-addr', 'url', 'user-account', 'windows-registry-key', 'x509-certificate']

dni_probability_scale = [	"1-5 = almost no chance", 
									"5-20 = very unlikely", 
									"20-45 = unlikely", 
									"45-55 = roughly even chance", 
									"55-80 = likely", 
									"80-95 = very likely", 
									"95-99 = almost certain"]

arg_parser = argparse.ArgumentParser(epilog =	"Example Patterns: " +
																"[ipv4-addr:value = '203.0.113.1' OR ipv4-addr:value = '203.0.113.2']; " +
																"([ipv4-addr:value = '198.51.100.5' ] AND [ipv4-addr:value = '198.51.100.10']) WITHIN 300 SECONDS; " +
																"[file:name = 'foo.dll'] START t'2016-06-01T00:00:00Z' STOP t'2016-07-01T00:00:00Z'; " +
																"[ipv4-addr:value = '198.51.100.5'] AND [ ipv4-addr:value = '198.51.100.10']; " +
																"[file:size = 25536]")

# Indicator Properties
arg_parser.add_argument("-p", "--pattern", required = True, \
								help = "{" + ", ".join(pattern_objects) + "} (" + pattern_ref_url + ")")
arg_parser.add_argument("-s", "--validfrom", required = True, \
								help = '"The time from which this Indicator is considered a valid indicator of the behaviors it is related or ' \
								'represents."')
arg_parser.add_argument("-e", "--validuntil", \
								help = 	'"The time at which this Indicator should no longer be considered a valid indicator of the behaviors ' \
								'it is related to or represents."')
arg_parser.add_argument("-n", "--name", \
								help = '"A name used to identify the Indicator. "')
arg_parser.add_argument("-d", "--description", \
								help = '"A description that provides more details and context about the Indicator, potentially including its ' \
								'purpose and its key characteristics."')
arg_parser.add_argument("-t", "--type", metavar = "TYPE", action = 'append', choices = type_choices, \
								help = "{" + ", ".join(type_choices) + "}")
arg_parser.add_argument("-x", "--tactic", metavar = "TACTIC", action = 'append', choices = tactic_choices, \
								help = "{" + ", ".join(tactic_choices) + "}")

# Common Properties
arg_parser.add_argument("-c", "--createdby", \
								help = 	'"The created_by_ref property specifies the id property of the identity object that describes the ' \
								'entity that created this object."')
arg_parser.add_argument("-l", "--label", action = 'append', \
								help = 	'"The labels property specifies a set of terms used to describe this object. The terms are user-defined ' \
								'or trust-group defined and their meaning is outside the scope of this specification and MAY be ignored."')
arg_parser.add_argument("-r", "--confidence", metavar = 'CONFIDENCE', type=int, choices = range(1, 100), \
								help = "{" + ", ".join(dni_probability_scale)+ "}")

# ExternalReference Properties
arg_parser.add_argument("--source", \
								help = '"The name of the source that the external-reference is defined within (system, registry, organization, ' \
								'etc.)."')
arg_parser.add_argument("--sourceid", \
								help = '"An identifier for the external reference content."')

# Note Properties
arg_parser.add_argument("--note", \
								help = '"The content of the note."')

# Other Options
arg_parser.add_argument("-o", "--repository", \
								help = "Output directory for the resulting object.")
arg_parser.add_argument("-v", "--version", action = 'version', version = '%(prog)s ' + version)

args = vars(arg_parser.parse_args())

mitre_tactics = []
if args['tactic']:
	for i in args['tactic']:
		mitre_tactics.append(KillChainPhase(kill_chain_name='mitre-attack', phase_name=i))

object = Indicator(	type = "indicator",
							name = args['name'],
							description = args['description'],
							indicator_types = args['type'],
							pattern_type = "stix",
							pattern = "[" + args['pattern'] + "]",
							kill_chain_phases = mitre_tactics,
							valid_from = args['validfrom'],
							valid_until = args['validuntil'],
							created_by_ref = args['createdby'])
print(object.serialize(pretty = True))

# Wrap a 'Note' around an 'ExternalReference' and link the above object to the note.
# Allows indicators to be used across domains and/or shared w/o associating internal
# details.
if	args['label'] or \
	args['confidence'] or \
	args['source'] or \
	args['sourceid'] or \
	args['note']:
	note = Note(type = "note",
					content = args['note'] if args['note'] else "Note",
					object_refs = object.id,
					created_by_ref = args['createdby'],
					labels = args['label'],
					confidence = args['confidence'],
					external_references = ExternalReference(	source_name = args['source'], 
																			external_id = args['sourceid']))
	print(note.serialize(pretty = True))

if args['repository']:
	fs_sink = FileSystemSink(args['repository'])
	fs_sink.add(object)
	fs_sink.add(note)
