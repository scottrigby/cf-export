# cf-export

Codefresh image feature request demo for a `CF_PR_NUMBER` ENV var.

## Test steps

### Set up a GitHub repo for a Codefresh pipeline

In GitHub UI:

1. Create and save a new [GitHub Personal access token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/), setting the `repo` scope
1. Create a new test repo

### Set up a Codefresh pipeline

In Codefresh UI:

1. Create a [Codefresh account](https://docs.codefresh.io/docs/create-an-account) with a GitHub user
    > Currently, it is possible to have only one git provider per account. You have to create a separate Codefresh account for each of your git providers.
1. Add a [(GitHub) repository](https://docs.codefresh.io/docs/getting-started-create-a-basic-pipeline)
1. Select only `Pull request opened` under `Configuration` > `General Settings` > `Automated build` > `Trigger by`
1. Under Codefresh UI `Environment Variables` add `GITHUB_TOKEN` with the token you created above
1. Under `WORKFLOW` toggle from `Basic` to `YAML`, and select `Inline YAML`
1. In the inline YAML textarea, add this example YAML and click `Save`

    ```yaml
    version: '1.0'
    steps:
    CFExport:
        title: Export CF_PR_NUMBER ENV var
        image: r6by/cf-export
    CFRead:
        title: Test read CF ENV vars
        image: alpine:latest
        commands:
        - env | grep CF_PR_NUMBER
    ```

### Create a new pull request

In GitHub UI:

1. Browse to your new test repo
1. Click [Create new file](https://help.github.com/articles/creating-new-files/)
1. Name your file `test` (file can be empty), select `Create a new branch for this commit and start a pull request`, and click `Propose new file`
1. On the next page, click `Create pull request`

### Check the codefresh pipeline build logs

In Codefresh UI:

1. Browse to `Builds`, and click `View log` next to the build that should have triggered from your new PR.
1. The `Test read CF ENV vars` step should output `CF_PR_NUMBER=1`, where `1` is the number of your new PR.
1. Create another pull request, and ensure `CF_PR_NUMBER` matches the new PR number.
