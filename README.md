# Week2 Solution 2019

A link to your API should be included [HERE](link)

To setup your local development environment run:
```
bash ./scripts/setup_local_dev_environment.sh
```

Run the API locally with docker-compose:
```
bash ./scripts/start_local.sh
```

Deploy to AWS (NOTE: terraform credentials need to be in your `~/.aws/credentials` file):
- Initialize the working directory with the Terraform configuration.
    ```
    terraform init
    ```
- Run the deploy script:
    ```
    bash ./scripts/deploy.sh
    ```
