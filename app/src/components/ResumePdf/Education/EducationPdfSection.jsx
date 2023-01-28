import { View, StyleSheet } from '@react-pdf/renderer';
import Title from '../Setup/Title';
import EducationPdfEntry from './EducationPdfEntry';
import PropTypes from 'prop-types';

const styles = StyleSheet.create({
  container: {
    paddingTop: 30,
    paddingLeft: 15,
  },
});

const EducationPdfSection = ({ data }) => (
  <View style={styles.container}>
    <Title>Education</Title>
    <View>    
      {data.map((degree) => (
        <EducationPdfEntry
          data={degree}
          key={degree.school}
        />
      ))}
    </View>
  </View>
);

EducationPdfSection.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape({
    school: PropTypes.string,
    degree: PropTypes.string,
    daterange: PropTypes.string,
    points: PropTypes.arrayOf(PropTypes.string),
  })),
};

EducationPdfSection.defaultProps = {
  data: [],
};

export default EducationPdfSection;