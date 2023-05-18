How do I find all resources created in the last thirty minutes?
***************************************************************

`doc <https://docs.aws.amazon.com/prescriptive-guidance/latest/patterns/
find-aws-resources-based-on-their-creation-date-by-using-aws-config-advanced-queries.html>`_.

Show all resources created since yesterday::

  aws configservice select-resource-config \
    --expression "SELECT resourceId, resourceType, resourceCreationTime
                  WHERE resourceCreationTime
                  BETWEEN '$(date -I)' and '$(date -d yesterday)'" \
    --query Results[] \
    --output text | jq .
