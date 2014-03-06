/*
 * Forms PL/SQL Extractor
 * Copyright (C) 2014 SonarSource
 * dev@sonar.codehaus.org
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02
 */
package org.sonar.oracleforms.plsql;

import org.junit.Test;

import static org.fest.assertions.Assertions.assertThat;

public class NodeTest {

  @Test
  public void keyShouldNotContainNull() {
    assertThat(new Node(null, "foo").getKey()).doesNotContain("null");
  }

  @Test
  public void to_string() {
    assertThat(new Node("FORMULA-CALCULATION").toString()).isEqualTo("Node[path=<null>,name=FORMULA-CALCULATION,plsql=<null>,type=<null>,children=[],parentName=<null>]");
  }

  @Test
  public void keyShouldStartBySlash() {
    assertThat(new Node("foo").getKey()).isEqualTo("/foo");
    assertThat(new Node(new Node("parent"), "foo").getKey()).isEqualTo("/parent/foo");
  }

  @Test
  public void calculatedFields() {
    assertThat(new Node("FORMULA-CALCULATION").isCalculatedField()).isTrue();
    assertThat(new Node("foo").isCalculatedField()).isFalse();
  }

  @Test
  public void hasPlsql() {
    Node foo = new Node("foo");
    assertThat(foo.setPlsql(" ").hasPlsql()).isFalse();
    assertThat(foo.setPlsql("").hasPlsql()).isFalse();
    assertThat(foo.setPlsql(null).hasPlsql()).isFalse();
    assertThat(foo.setPlsql("some sql").hasPlsql()).isTrue();
  }

  @Test
  public void isAlias() {
    Node pUnit = new Node("program unit");
    assertThat(pUnit.isAlias()).isFalse();
    pUnit.setParentName(null);
    assertThat(pUnit.isAlias()).isFalse();
    pUnit.setParentName("Another Form");
    assertThat(pUnit.isAlias()).isTrue();
  }

  @Test
  public void plsqlNameDoesNotContainMinus() {
    assertThat(new Node("foo").getPlsqlName()).isEqualTo("foo");
    assertThat(new Node("foo-bar").getPlsqlName()).isEqualTo("foo_bar");
    assertThat(new Node("foo_bar").getPlsqlName()).isEqualTo("foo_bar");
  }

}
