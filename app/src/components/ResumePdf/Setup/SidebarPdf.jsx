import React from 'react';
import { View, Image, Text, StyleSheet } from '@react-pdf/renderer';
import SidebarList from './SidebarList';
import selectedSkills from '../../../data/resume/selectedSkills';
import thingsILike from '../../../data/resume/thingsILike';

const styles = StyleSheet.create({
  sidebar: {
    flexDirection: 'column',
    width: 160,
    margin: 10,
    padding: 10,
    paddingTop: 20,
  },
  image: {
    marginBottom: 10,
    width: 140,
    borderRadius: '50%',
  },
  sidebarHeaderText: {
    fontFamily: 'Raleway',
    fontSize: 20,
    fontWeight: 800,
    paddingTop: 20,
    paddingBottom: 20,
    textTransform: 'uppercase',
  },
  sidebarContactEntry: {
    flexDirection: 'row',
  },
  sidebarContactText: {
    fontFamily: 'Raleway',
    fontSize: 9,
    fontWeight: 400,
    paddingLeft: 8,
  },
  sidebarContactIcon: {
    width: 10,
  },
  sidebarGreetingText: {
    paddingTop: 20,
    fontFamily: 'Raleway',
    fontSize: 9,
    fontWeight: 800,
  },
});


const SidebarPdf = () => (
  <View style={styles.sidebar}>
    <View>
      <Image src={'/images/me.png'} style={styles.image} />
    </View>
    <View>
      <Text style={styles.sidebarHeaderText} >Kristian{'\n'}Sørensen{'\n'}Stene</Text>
    </View>
    <View style={styles.sidebarContactEntry}>
      <Image src={'/images/pdf/mail-30.png'} style={styles.sidebarContactIcon}/>
      <Text style={styles.sidebarContactText} >kristian@sorensenstene.site</Text>
    </View>
    <View style={styles.sidebarContactEntry}>
      <Image src={'/images/pdf/phone-30.png'} style={styles.sidebarContactIcon}/>
      <Text style={styles.sidebarContactText} >+47 936 37 449</Text>
    </View>
    <View style={styles.sidebarContactEntry}>
      <Image src={'/images/pdf/website-30.png'} style={styles.sidebarContactIcon}/>
      <Text style={styles.sidebarContactText} >www.sorensenstene.site</Text>
    </View>
    <Text style={styles.sidebarGreetingText}>
      Hi, I'm Kristian.{'\n'}
      I like building things.{'\n'}
      I am a NTNU graduate, seaman, and SRE/Platform Engineer.
    </Text>
    <View style={{paddingTop:20}}>
      <SidebarList header='Skills' points={selectedSkills}/>
    </View>
    <View style={{paddingTop:20}}>
      <SidebarList header='Things I like' points={thingsILike}/>
    </View>
  </View>
);

export default SidebarPdf;