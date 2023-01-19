import { faGithub } from '@fortawesome/free-brands-svg-icons/faGithub';
import { faLinkedinIn } from '@fortawesome/free-brands-svg-icons/faLinkedinIn';
import { faEnvelope } from '@fortawesome/free-regular-svg-icons/faEnvelope';
// See https://fontawesome.com/icons?d=gallery&s=brands,regular&m=free
// to add other icons.

const data = [
  {
    link: 'https://github.com/kristeey',
    label: 'Github',
    icon: faGithub,
  },
  {
    link: 'https://no.linkedin.com/in/kristian-s%C3%B8rensen-stene-6b0493166',
    label: 'LinkedIn',
    icon: faLinkedinIn,
  },
  {
    link: 'mailto:kristian@sorensenstene.site',
    label: 'Email',
    icon: faEnvelope,
  },
];

export default data;
