import React from 'react';
import { Link } from 'react-router-dom';
import Main from '../layouts/Main';

const { PUBLIC_URL } = process.env;

const Index = () => (
  <Main
    description={"Kristian Sørensen Stene's personal website. Bergen based NTNU graduate, "
    + 'seaman, creator and Platform Engineering enthusiast.'}
  >
    <article className="post" id="index">
      <header>
        <div className="title">
          <h2 data-testid="heading"><Link to="/">About this site</Link></h2>
          <p>
            This is my personal website. Here you can learn a great deal about me and my work.
          </p>
        </div>
      </header>
      <p> This website is a React application written in modern JavaScript built using
        state of the art tooling. The technology stack is a bit overkill for running this
        application, but very cool. The main parts are described below:
        <ul>
          <li>
            Code version control is handled by Git, and the code is stored in GitHub.
          </li>
          <li>
            Terraform is used to provision infrastructure in AWS cloud. EKS is
            bootstrapped with FluxCD amongs other things.
          </li>
          <li>
            Github action is used to build and push application docker images to ECR.
          </li>
          <li>FluxCD provides GitOps automating application image updates, installes addons,
            and uses the Github repo as source of truth for kubernetes manifests.
          </li>
          <li>
            Kubevela is used to customize Application components such that application
            manifests are easy to configure and maintain.
          </li>
          <li>
            ExternalDNS is installed on the cluster to automate DNS record creation, and
            AWS Loadbalancer Controller is used to automate provisioning and management
            of Elastic Load Balancers for the kubernetes cluster.
          </li>
        </ul>
        Please feel free to check out my <Link to="/resume">resume</Link>, and do not
        hesitate to <Link to="/contact">contact</Link> me as well.
        You can find the source to this project <a href="https://github.com/kristeey/personal-resume-site">here</a>.
      </p>
      <img className="technologyImg" src={`${PUBLIC_URL}/images/technology-stack.png`} alt="" />
    </article>
  </Main>
);

export default Index;
