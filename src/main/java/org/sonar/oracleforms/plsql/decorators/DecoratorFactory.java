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
package org.sonar.oracleforms.plsql.decorators;

import org.apache.commons.lang.StringUtils;
import org.sonar.oracleforms.plsql.Node;

import java.util.Arrays;
import java.util.List;

public final class DecoratorFactory {

  private DecoratorFactory() {
    // only static methods
  }

  private static final List<Decorator> DECORATORS = Arrays.asList(new CalculatedFieldDecorator(),
      new GuiBlockDecorator(), new GuiItemDecorator(),
      new CommentPathDecorator(), new ProgramUnitDecorator());

  public static String decorate(Node node) {
    String plsql = StringUtils.defaultString(node.getPlsql());
    for (Decorator decorator : DECORATORS) {
      plsql = decorator.decorate(node, plsql);
    }
    return plsql;
  }

}
