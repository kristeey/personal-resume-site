import React from 'react';
import { Link } from 'react-router-dom';

import Main from '../layouts/Main';

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
            This is my personal website built with React running on Kubernetes in AWS overengineered
            with a lot of modern platform tooling.
          </p>
        </div>
      </header>
      <p> Welcome to my website.
        <ul>
          <li>The infrastructure is set up with Terraform.</li>
          <li>The deployment pipeline consist of GH actions using Docker to build conatiner
            images and push them to AWS conainer registry. We have FluxCD and Kubevela running in
            the cluster ensuring GitOps based platform agnostic application delivery.
          </li>
          <li>The cluster is monitored using metrics scraped with prometheus, and visualized with
            grafana. Network metrics are also scraped showing network traffic.
          </li>
          <li>Cillium is used to monitor network traffic, and enforce network policies</li>
        </ul>
        Please feel free to read more <Link to="/about">about the platform</Link> behind this webpage,
        or you can check out my {' '}
        <Link to="/resume">resume</Link>, {' '}
        or <Link to="/contact">contact</Link> me.
      </p>
    </article>
  </Main>
);

export default Index;
