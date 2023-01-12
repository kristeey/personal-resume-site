// TODO: Add Athletic Skills, Office Skills,
// Data Engineering, Data Science, ML Engineering, ... ?

const skills = [
  {
    title: 'Javascript',
    competency: 3,
    category: ['Languages'],
  },
  {
    title: 'Bash',
    competency: 3,
    category: ['Languages'],
  },
  {
    title: 'C',
    competency: 1,
    category: ['Languages'],
  },
  {
    title: 'C++',
    competency: 3,
    category: ['Languages'],
  },
  {
    title: 'python',
    competency: 4,
    category: ['Languages'],
  },
  {
    title: 'go',
    competency: 3,
    category: ['Languages'],
  },
  {
    title: 'Rust',
    competency: 1,
    category: ['Languages'],
  },
  {
    title: 'Dart',
    competency: 3,
    category: ['Languages'],
  },
  {
    title: 'CUE',
    competency: 2,
    category: ['Languages'],
  },
  {
    title: 'MATLAB',
    competency: 3,
    category: ['Languages'],
  },
  {
    title: 'Azure',
    competency: 3,
    category: ['Cloud Providers'],
  },
  {
    title: 'GCP',
    competency: 4,
    category: ['Cloud Providers'],
  },
  {
    title: 'AWS',
    competency: 2,
    category: ['Cloud Providers'],
  },
  {
    title: 'FluxCD',
    competency: 4,
    category: ['Kubernetes Tools'],
  },
  {
    title: 'KubeVela',
    competency: 3,
    category: ['Kubernetes Tools'],
  },
  {
    title: 'Prometheus',
    competency: 3,
    category: ['Kubernetes Tools'],
  },
  {
    title: 'Grafana',
    competency: 3,
    category: ['Kubernetes Tools'],
  },
  {
    title: 'Alertmanager',
    competency: 3,
    category: ['Kubernetes Tools'],
  },
  {
    title: 'Certmanager',
    competency: 3,
    category: ['Kubernetes Tools'],
  },
  {
    title: 'Cillium',
    competency: 1,
    category: ['Kubernetes Tools'],
  },
  {
    title: 'Backstage',
    competency: 1,
    category: ['Kubernetes Tools'],
  },
  {
    title: 'Velero',
    competency: 2,
    category: ['Kubernetes Tools'],
  },
  {
    title: 'Github Actions',
    competency: 5,
    category: ['Tools'],
  },
  {
    title: 'Circle CI',
    competency: 2,
    category: ['Tools'],
  },
  {
    title: 'Terraform',
    competency: 4,
    category: ['Tools'],
  },
  {
    title: 'Git',
    competency: 5,
    category: ['Tools'],
  },
  {
    title: 'Kubernetes',
    competency: 4,
    category: ['Tools'],
  },
  {
    title: 'Docker',
    competency: 3,
    category: ['Tools'],
  },
].map((skill) => ({ ...skill, category: skill.category.sort() }));

// this is a list of colors that I like. The length should be == to the
// number of categories. Re-arrange this list until you find a pattern you like.
const colors = [
  '#6968b3',
  '#37b1f5',
  '#40494e',
  '#515dd4',
  '#e47272',
  '#cc7b94',
  '#3896e2',
  '#c3423f',
  '#d75858',
  '#747fff',
  '#64cb7b',
];

const categories = [
  ...new Set(skills.reduce((acc, { category }) => acc.concat(category), [])),
]
  .sort()
  .map((category, index) => ({
    name: category,
    color: colors[index],
  }));

export { categories, skills };
