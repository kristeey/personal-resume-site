import React from 'react';
import { Link } from 'react-router-dom';

import ContactIcons from '../Contact/ContactIcons';

const { PUBLIC_URL } = process.env; // set automatically from package.json:homepage

const SideBar = () => (
  <section id="sidebar">
    <section id="intro">
      <Link to="/" className="logo">
        <img src={`${PUBLIC_URL}/images/me.png`} alt="" />
      </Link>
      <header>
        <h2>Kristian Sørensen Stene</h2>
        <p><a href="mailto: kristian@sorensenstene.site"> kristian@sorensenstene.site</a></p>
      </header>
    </section>

    <section className="blurb">
      <h2>About</h2>
      <p>Hi, I&apos;m Kristian. I like building things.
        I am a <a href="https://www.ntnu.no/">NTNU</a> graduate, seaman, SRE/Platform Engineer.
      </p>
      <ul className="actions">
        <li>
          {!window.location.pathname.includes('/resume') ? <Link to="/resume" className="button">Learn More</Link> : <Link to="/about" className="button">About Me</Link>}
        </li>
      </ul>
    </section>

    <section id="footer">
      <ContactIcons />
      <p className="copyright">Kristian Sørensen Stene <Link to="/">sorensenstene.site</Link>.</p>
    </section>
  </section>
);

export default SideBar;
