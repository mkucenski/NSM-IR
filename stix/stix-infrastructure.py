#!/usr/bin/env python3

version = "1.0"

import argparse
from stix2 import Infrastructure, \
						FileSystemSink, \
						ExternalReference, \
						Note, \
						KillChainPhase

type_choices = [	'amplification', 'anonymization', 'botnet', 'command-and-control', 'exfiltration', 'hosting-malware', 
						'hosting-target-lists', 'phishing', 'reconnaissance', 'staging', 'unknown']

tactic_choices = ['reconnaissance', 'resource-development', 'initial-access', 'execution', 'persistence', 'privilege-execution', 
						'defense-evasion', 'credential-access', 'discovery', 'command-control', 'exfiltration', 'impact']

dni_probability_scale = [	"1-5 = almost no chance", 
									"5-20 = very unlikely", 
									"20-45 = unlikely", 
									"45-55 = roughly even chance", 
									"55-80 = likely", 
									"80-95 = very likely", 
									"95-99 = almost certain"]

arg_parser = argparse.ArgumentParser()

# Infrastructure Properties
arg_parser.add_argument("-n", "--name", required = True, \
								help = '"A name or characterizing text used to identify the Infrastructure."')
arg_parser.add_argument("-d", "--description", \
								help = '"A description that provides more details and context about the Infrastructure, potentially including ' \
								'its purpose, how it is being used, how it relates to other intelligence activities captured in related objects, ' \
								'and its key characteristics."')
arg_parser.add_argument("-t", "--type", metavar = "TYPE", action = 'append', choices = type_choices, \
								help = "{" + ", ".join(type_choices) + "}")
arg_parser.add_argument("-a", "--alias", \
								help = '"Alternative names used to identify this Infrastructure."')
arg_parser.add_argument("-x", "--tactic", metavar = "TACTIC", action = 'append', choices = tactic_choices, \
								help = "{" + ", ".join(tactic_choices) + "}")
arg_parser.add_argument("-s", "--firstseen", \
								help = '"The time that this Infrastructure was first seen performing malicious activities."')
arg_parser.add_argument("-e", "--lastseen", \
								help = '"The time that this Infrastructure was last seen performing malicious activities."')

# Common Properties
arg_parser.add_argument("-c", "--createdby", \
								help = 	'"The created_by_ref property specifies the id property of the identity object that describes the entity ' \
								'that created this object."')
arg_parser.add_argument("-l", "--label", action = 'append', \
								help = 	'"The labels property specifies a set of terms used to describe this object. The terms are user-defined ' \
								'or trust-group defined and their meaning is outside the scope of this specification and MAY be ignored."')
arg_parser.add_argument("-r", "--confidence", metavar = '%', choices = range(0, 101), \
								help = "{" + ", ".join(dni_probability_scale)+ "}")

# TODO This SDO is meant to combine other objects as a group of inter-related entities.

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

object = Infrastructure(type = "infrastructure",
								name = args['name'],
								description = args['description'],
								infrastructure_types = args['type'],
								aliases = args['alias'],
								kill_chain_phases = mitre_tactics,
								first_seen = args['firstseen'],
								last_seen = args['lastseen'],
								created_by_ref = args['createdby'],
								labels = args['label'],
								confidence = args['confidence'])
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

