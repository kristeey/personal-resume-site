import { View, StyleSheet } from '@react-pdf/renderer';
import Title from '../Setup/Title';
import VoluntaryPdfEntry from './VoluntaryPdfEntry';
import PropTypes from 'prop-types';

const styles = StyleSheet.create({
  container: {
    padding: 10,
  },
});

const VoluntaryPdfSection = ({ data }) => (
  <View style={styles.container}>
    <Title>Voluntary Work</Title>
    <View>    
      {data.map((voluntaryWork) => (
        <VoluntaryPdfEntry
          data={voluntaryWork}
          key={voluntaryWork.title}
        />
      ))}
    </View>
  </View>
);

VoluntaryPdfSection.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape({
    title: PropTypes.string,
    daterange: PropTypes.string,
    points: PropTypes.arrayOf(PropTypes.string),
  })),
};

VoluntaryPdfSection.defaultProps = {
  data: [],
};

export default VoluntaryPdfSection;