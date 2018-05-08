"""Add bindings to a JSON IAM policy.

Example usage:
  IAM_DIR=/tmp/iams
  IAM_FILE=${IAM_DIR}/${PROJECT_ID}.iam.json
  mkdir -p ${IAM_DIR}
  gcloud projects get-iam-policy ${PROJECT_ID} --format=json > ${IAM_FILE}
  python /tmp/add_bindings.py --input ${IAM_FILE} --role roles/editor --members editor@example.com
"""
import argparse
import json
import sys


def get_binding_by_role(policy, role):
  for binding in policy['bindings']:
    if binding['role'] == role:
      return binding
  return None


def add_bindings(policy, role, members):
  binding = get_binding_by_role(policy, role)
  if binding:
    binding['members'].extend(members)
  else:
    policy['bindings'].append({
      'role': role,
      'members': members
    })
  return policy


if __name__ == '__main__':
  parser = argparse.ArgumentParser()
  parser.add_argument('--role', type=str, dest='role',
                      help='A role to add members to.')
  parser.add_argument('--members', type=str, dest='members',
                      nargs='+', help='Members to add to the role.')
  parser.add_argument('--input', type=str, dest='input')
  parser.add_argument('--output', default=None, type=str, dest='output')
  args = parser.parse_args()

  if not args.output:
    args.output = args.input

  with open(args.input) as f:
    policy = json.load(f)

  with open(args.output, 'w') as f:
    json.dump(add_bindings(policy, args.role, args.members), f,
              indent=2, separators=(',', ': '))
