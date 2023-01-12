# Personal Resume Website

## About
This is the source to my personal resume website. It consists of four main parts:

1. `./app` contains the React app and Dockerfile for building it. It is a fork from [mldangelo/personal-site](https://github.com/mldangelo/personal-site) and edited to suit my needs.

2. `./terraform` contains the HCL code to provision infrastructure on AWS cloud. Everything needed to get the webside up and running is provisioned on apply. The only manual step is to create the certificate in ACM [see TODO](##todo).

3. `./gitops` contains the kubernetes manifests for cluster tooling and the application itself. This is what FluxCD (which was installed in the cluster by terraform) will use as source of thruth, and update image versions of the application. 

4. `./.github/workflows` contains github actions workflows. One workflow builds and pushes app docker images to ECR.

## Todo
- [Change the nginx config](https://stackoverflow.com/questions/45598779/react-router-browserrouter-leads-to-404-not-found-nginx-error-when-going-to) to serve every routes subdirectory correctly. As of now will give 404 upon refresh on subdriectories.
- Install Prometheus and make a Grafana dashboard, and update app to generate app metrics.
- Install Cilium for network policies and scrape network metrics. Explore Wireguard.
- Make Terraform modules to cluster similar resources together, improve readability ,and improve resource dependency. 
- Add TLS certificate provisioning and validation to Terraform code.
- Make github action workflow for updating kubevela Application revisions.
