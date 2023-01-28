import React from 'react';
import { Document, Page, View, StyleSheet, Font } from '@react-pdf/renderer';

import ExperiencePdfSection from './Experience/ExperiencePdfSection';
import EducationPdfSection from './Education/EducationPdfSection';
import Summary from './Summary/Summary';
import SidebarPdf from './Setup/SidebarPdf';
import positions from '../../data/resume/positions';
import degrees from '../../data/resume/degrees';
import summary from '../../data/resume/summary';

const styles = StyleSheet.create({
  page: {
    backgroundColor: '#e3e3e3',
    display: 'flex',
    flexDirection: 'row',
    paddingTop: 30,
  },
  rightContainer: {
    backgroundColor: '#ffffff',
    marginTop: -30,
    marginBottom: -30,
    padding: 10,
    paddingRight: 20,
    paddingTop: 30,
    width: 435,
  },
});

Font.register({ family: 'Raleway', fonts: [
  {src: 'https://fonts.gstatic.com/s/raleway/v28/1Ptxg8zYS_SKggPN4iEgvnHyvveLxVtaooCP.ttf', fontStyle: 'normal', fontWeight: 200},
  {src: 'https://fonts.gstatic.com/s/raleway/v28/1Ptxg8zYS_SKggPN4iEgvnHyvveLxVvaooCP.ttf', fontStyle: 'normal', fontWeight: 400},
  {src: 'https://fonts.gstatic.com/s/raleway/v28/1Ptxg8zYS_SKggPN4iEgvnHyvveLxVtapYCP.ttf', fontStyle: 'normal', fontWeight: 800},
] 
});

const ResumePdf = () => (
  <Document>
    <Page size="A4" style={styles.page}>
      <View
        style={{
          backgroundColor: 'white',
          width: 420.53,
          height: 30,
          top: 0,
          right: 0,
          position: 'absolute',
        }}
        fixed
      />
      <SidebarPdf/>
      <View style={styles.rightContainer}>
        <Summary summary={summary}/>
        <EducationPdfSection data={degrees}/>
        <ExperiencePdfSection data={positions}/>
      </View>
    </Page>
  </Document>
);

export default ResumePdf;