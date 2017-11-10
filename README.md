# jenkins-inspector

Identify inefficient Jenkins jobs 

### Purpose

Jenkins Jobs have triggers that can query Git servers for updates on a regular basis - polling. This is usually in a `cron` format that tries to `fetch` changes and determine if the job should build. This is very inefficient since the majority of queries don't trigger a build and that multiple `git push` events could happen within this window. Instead, Git SCM jobs should use webhooks to queue builds.

This script can help Jenkins Admins detect when Jobs are configured to poll Git SCM systems.

### Usage

Add Environment Variables that includes a FQDN to your Jenkins instancw with credentials that can access all Jobs.

