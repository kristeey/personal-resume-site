import { View, StyleSheet } from '@react-pdf/renderer';
import Title from '../Setup/Title';
import ExperiencePdfEntry from './ExperiencePdfEntry';
import PropTypes from 'prop-types';

const styles = StyleSheet.create({
  container: {
    padding: 10,
  },
});

const ExperiencePdfSection = ({ data }) => (
  <View style={styles.container}>
    <Title>Experience</Title>
    <View>    
      {data.map((experience) => (
        <ExperiencePdfEntry
          data={experience}
          key={experience.company}
        />
      ))}
    </View>
  </View>
);

ExperiencePdfSection.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape({
    company: PropTypes.string.isRequired,
    position: PropTypes.string,
    positionType: PropTypes.string,
    daterange: PropTypes.string,
    points: PropTypes.arrayOf(PropTypes.string),
  })),
};

ExperiencePdfSection.defaultProps = {
  data: [],
};

export default ExperiencePdfSection;