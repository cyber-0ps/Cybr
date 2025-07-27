Feature: S3 related general Feature

    Scenario: Data must be encrypted at rest
        Given I have aws_s2_bucket defined
        Then it must have aws_s3_bucker_server_side_encryption_configuration